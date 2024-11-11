USE MCMS;

-- Procedimiento para actualizar el estado de un activo:

DROP PROCEDURE IF EXISTS sp_actualizar_estado_activo;
DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_activo(
    IN activo_id INT, 
    IN nuevo_estado ENUM('Activo', 'En Reparación', 'Dado de Baja')
)
BEGIN
    UPDATE Activos SET Estado = nuevo_estado WHERE ID_Activo = activo_id;
END//
DELIMITER ;

-- Procedimiento para actualizar el stock de inventario:
DROP PROCEDURE IF EXISTS sp_insertar_inventario;
DELIMITER //
CREATE PROCEDURE sp_insertar_inventario(
    IN material_id INT,
    IN cantidad INT,
    IN cantidad_minima INT,
    IN id_ubicacion INT
)
BEGIN
    -- Insertar una nueva entrada en Inventario
    INSERT INTO Inventario (ID_Material, Cantidad_Disponible, Cantidad_Minima, ID_Ubicacion)
    VALUES (material_id, cantidad, cantidad_minima, id_ubicacion);
END //
DELIMITER ;

-- Procedimiento para generar programación de mantenimiento preventivo:
DROP PROCEDURE IF EXISTS sp_generar_programacion;
DELIMITER //
CREATE PROCEDURE sp_generar_programacion(
    IN activo_id INT,
    IN frecuencia ENUM('Diaria', 'Semanal', 'Mensual', 'Anual')
)
BEGIN
    DECLARE proxima_fecha DATE;
    
    SET proxima_fecha = CASE 
        WHEN frecuencia = 'Diaria' THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)
        WHEN frecuencia = 'Semanal' THEN DATE_ADD(CURDATE(), INTERVAL 1 WEEK)
        WHEN frecuencia = 'Mensual' THEN DATE_ADD(CURDATE(), INTERVAL 1 MONTH)
        WHEN frecuencia = 'Anual' THEN DATE_ADD(CURDATE(), INTERVAL 1 YEAR)
    END;
    
    INSERT INTO Programacion_Mantenimiento (ID_Activo, Frecuencia, Proxima_Fecha)
    VALUES (activo_id, frecuencia, proxima_fecha);
END//
DELIMITER ;

-- Procedimiento para generar un pedido automático:
DROP PROCEDURE IF EXISTS sp_generar_pedido;
DELIMITER //
CREATE PROCEDURE sp_generar_pedido(
    IN proveedor_id INT,
    IN material_id INT,
    IN cantidad INT
)
BEGIN
    INSERT INTO Pedidos (ID_Proveedor, Fecha_Pedido, Estado, Total)
    VALUES (proveedor_id, CURDATE(), 'Pendiente', 0);

    INSERT INTO Detalle_Pedido (ID_Pedido, ID_Material, Cantidad, Costo)
    VALUES (LAST_INSERT_ID(), material_id, cantidad, (SELECT Costo FROM Materiales WHERE ID_Material = material_id));

    UPDATE Pedidos SET Total = (SELECT SUM(Cantidad * Costo) FROM Detalle_Pedido WHERE ID_Pedido = LAST_INSERT_ID())
    WHERE ID_Pedido = LAST_INSERT_ID();
END//
DELIMITER ;

-- Procedimiento para registrar un nuevo pedido de material
DROP PROCEDURE IF EXISTS registrar_pedido_material;
DELIMITER //
CREATE PROCEDURE registrar_pedido_material (
    IN p_proveedor_id INT,
    IN p_material_id INT,
    IN p_cantidad INT,
    IN p_costo DECIMAL(10, 2)
)
BEGIN
    DECLARE pedido_id INT;

    -- Crear el pedido
    INSERT INTO Pedidos (ID_Proveedor, Fecha_Pedido, Estado, Total)
    VALUES (p_proveedor_id, NOW(), 'Pendiente', p_cantidad * p_costo);

    SET pedido_id = LAST_INSERT_ID();

    -- Crear el detalle del pedido
    INSERT INTO Detalle_Pedido (ID_Pedido, ID_Material, Cantidad, Costo)
    VALUES (pedido_id, p_material_id, p_cantidad, p_costo);
END //
DELIMITER ;

-- Procedimiento para registrar una recepción de pedido
DROP PROCEDURE IF EXISTS registrar_recepcion_pedido;
DELIMITER //
CREATE PROCEDURE registrar_recepcion_pedido (
    IN p_pedido_id INT
)
BEGIN
    -- Marcar el pedido como recibido
    UPDATE Pedidos
    SET Estado = 'Recibido'
    WHERE ID_Pedido = p_pedido_id;

    -- Crear una recepción para el pedido
    INSERT INTO Recepciones (ID_Pedido, Fecha_Recepcion, Estado)
    VALUES (p_pedido_id, NOW(), 'Completada');
END //
DELIMITER ;

-- generar una nueva orden de mantenimiento
DROP PROCEDURE IF EXISTS generar_orden_mantenimiento;
DELIMITER //
CREATE PROCEDURE generar_orden_mantenimiento(
    IN p_ID_Activo INT,
    IN p_Tipo_Mantenimiento ENUM('Preventivo', 'Correctivo'),
    IN p_Descripcion TEXT,
    IN p_Tareas JSON  -- Tareas en formato JSON simplificado: '[["Tarea 1", "Juan"], ["Tarea 2", "Maria"]]'
)
BEGIN
    -- Variables para manejar las tareas desde el JSON
    DECLARE v_ID_Orden INT;
    DECLARE v_Index INT DEFAULT 0;
    DECLARE v_Tarea_Descripcion TEXT;
    DECLARE v_Tarea_Responsable VARCHAR(100);
    DECLARE v_Total_Tareas INT;

    -- Insertar una nueva orden de mantenimiento
    INSERT INTO Ordenes_Mantenimiento (ID_Activo, Tipo_Mantenimiento, Fecha_Inicio, Estado, Descripcion)
    VALUES (p_ID_Activo, p_Tipo_Mantenimiento, CURDATE(), 'Pendiente', p_Descripcion);

    -- Obtener el ID de la orden creada
    SET v_ID_Orden = LAST_INSERT_ID();

    -- Número total de tareas en el JSON
    SET v_Total_Tareas = JSON_LENGTH(p_Tareas);

    -- Iterar sobre cada tarea en el JSON e insertarla en la tabla Tareas
    WHILE v_Index < v_Total_Tareas DO
        SET v_Tarea_Descripcion = JSON_UNQUOTE(JSON_EXTRACT(p_Tareas, CONCAT('$[', v_Index, '][0]')));
        SET v_Tarea_Responsable = JSON_UNQUOTE(JSON_EXTRACT(p_Tareas, CONCAT('$[', v_Index, '][1]')));

        INSERT INTO Tareas (ID_Orden, Descripcion, Estado, Responsable)
        VALUES (v_ID_Orden, v_Tarea_Descripcion, 'Pendiente', v_Tarea_Responsable);

        SET v_Index = v_Index + 1;
    END WHILE;
END //
DELIMITER ;


-- finalizar las ordenes de mantenimiento y sus tareas
DROP PROCEDURE IF EXISTS finalizar_orden_mantenimiento;
DELIMITER //
CREATE PROCEDURE finalizar_orden_mantenimiento(
    IN p_ID_Orden INT
)
BEGIN
    -- Actualizar el estado de la orden de mantenimiento
    UPDATE Ordenes_Mantenimiento
    SET Estado = 'Completado', Fecha_Fin = CURDATE()
    WHERE ID_Orden = p_ID_Orden;

    -- Actualizar el estado de las tareas asociadas a la orden de mantenimiento
    UPDATE Tareas
    SET Estado = 'Completada'
    WHERE ID_Orden = p_ID_Orden AND Estado != 'Completada';
END //

DELIMITER ;

-- Crear un activo nuevo
DROP PROCEDURE IF EXISTS crear_activo;
DELIMITER //
CREATE PROCEDURE crear_activo(
    IN p_Tipo VARCHAR(50),
    IN p_Descripcion TEXT,
    IN p_Fecha_Compra DATE,
    IN p_Proveedor VARCHAR(100),
    IN p_Valor DECIMAL(10, 2),
    IN p_ID_Ubicacion INT
)
BEGIN
    INSERT INTO Activos (Tipo, Descripcion, Fecha_Compra, Proveedor, Valor, ID_Ubicacion)
    VALUES (p_Tipo, p_Descripcion, p_Fecha_Compra, p_Proveedor, p_Valor, p_ID_Ubicacion);
END //
DELIMITER ;

-- Crear repuestos nuevos
DROP PROCEDURE IF EXISTS crear_material;
DELIMITER //
CREATE PROCEDURE crear_material(
    IN p_Nombre VARCHAR(100),
    IN p_Descripcion TEXT,
    IN p_ID_Proveedor INT,
    IN p_Unidad_Medida VARCHAR(20)
)
BEGIN
    INSERT INTO Materiales (Nombre, Descripcion, ID_Proveedor, Unidad_Medida)
    VALUES (p_Nombre, p_Descripcion, p_ID_Proveedor, p_Unidad_Medida);
END //
DELIMITER ;
