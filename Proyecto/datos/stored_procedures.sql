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
DROP PROCEDURE IF EXISTS sp_actualizar_stock;
DELIMITER //
CREATE PROCEDURE sp_actualizar_stock(
    IN material_id INT,
    IN cantidad INT
)
BEGIN
    UPDATE Inventario
    SET Cantidad_Disponible = Cantidad_Disponible + cantidad
    WHERE ID_Material = material_id;
END//
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
