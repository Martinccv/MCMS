
-- Procedimiento para actualizar el estado de un activo:
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
