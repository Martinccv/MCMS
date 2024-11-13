USE MCMS;

-- Trigger para actualizar historial de activo cuando cambia el estado:
DROP TRIGGER IF EXISTS trigger_estado_activo_cambio;
DELIMITER //
CREATE TRIGGER trigger_estado_activo_cambio
AFTER UPDATE ON Activos
FOR EACH ROW
BEGIN
    IF NEW.Estado <> OLD.Estado THEN
        INSERT INTO Historial_Activo (ID_Activo, Fecha, Descripcion, Costo, Responsable)
        VALUES (NEW.ID_Activo, NOW(), CONCAT('Cambio de estado a ', NEW.Estado), 0, 'Sistema');
    END IF;
END//
DELIMITER ;

-- Trigger para alertar cuando el inventario está bajo el mínimo
DROP TRIGGER IF EXISTS trigger_inventario_minimo;
DELIMITER //
CREATE TRIGGER trigger_inventario_minimo
BEFORE INSERT ON Inventario
FOR EACH ROW
BEGIN
    DECLARE v_Cantidad_Minima INT;
    DECLARE v_Stock_Total INT;
    DECLARE v_Mensaje TEXT;

    -- Obtener el valor mínimo permitido de la tabla Materiales
    SELECT 
        CASE Cantidad_Minima
            WHEN 'bajo' THEN 10
            WHEN 'medio_bajo' THEN 30
            WHEN 'medio' THEN 50
            WHEN 'medio-alto' THEN 100
            WHEN 'alto' THEN 200
        END INTO v_Cantidad_Minima
    FROM Materiales 
    WHERE ID_Material = NEW.ID_Material;

    -- Calcular el stock total para el mismo ID_Material y ID_Ubicacion
    SELECT COALESCE(SUM(Cantidad_Disponible), 0)
    INTO v_Stock_Total
    FROM Inventario
    WHERE ID_Material = NEW.ID_Material AND ID_Ubicacion = NEW.ID_Ubicacion;

    -- Verificar si el stock total después de la operación sería negativo
    IF v_Stock_Total + NEW.Cantidad_Disponible < 0 THEN
        SET v_Mensaje = 'Error: No hay suficiente stock para este material en la ubicación especificada.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_Mensaje;
    END IF;

    -- Insertar una alerta si el stock total está por debajo del mínimo permitido
    IF v_Stock_Total + NEW.Cantidad_Disponible <= v_Cantidad_Minima THEN
        INSERT INTO Alertas (Mensaje, Fecha)
        VALUES (
            CONCAT('Stock bajo para material ID ', NEW.ID_Material, ' en ubicación ID ', NEW.ID_Ubicacion), 
            NOW()
        );
    END IF;

END //
DELIMITER ;

-- Trigger para actualizar historial de mantenimiento al completar una orden:
DROP TRIGGER IF EXISTS trigger_orden_mantenimiento_completa;
DELIMITER //
CREATE TRIGGER trigger_orden_mantenimiento_completa
AFTER UPDATE ON Ordenes_Mantenimiento
FOR EACH ROW
BEGIN
    IF NEW.Estado = 'Completado' AND OLD.Estado <> 'Completado' THEN
        INSERT INTO Historial_Activo (ID_Activo, Fecha, Descripcion, Costo, Responsable)
        VALUES (NEW.ID_Activo, NOW(), 'Mantenimiento completado', 0, 'Técnico responsable');
    END IF;
END//
DELIMITER ;

-- actualizar detalle de pedido a completado
DROP TRIGGER IF EXISTS trigger_actualizar_detalle_pedido;
DELIMITER //

CREATE TRIGGER trigger_actualizar_detalle_pedido
AFTER INSERT ON Recepciones
FOR EACH ROW
BEGIN
    -- Actualizar el estado de los detalles de pedido a 'Completado' según ID_Pedido y ID_Ubicacion
    UPDATE Detalle_Pedido
    SET Estado = 'Completado'
    WHERE ID_Pedido = NEW.ID_Pedido AND ID_Ubicacion = NEW.ID_Ubicacion;
END //

DELIMITER ;

-- actualizar el estado de pedido cuando todos los detalles de pedido esten completos
DROP TRIGGER IF EXISTS trigger_actualizar_estado_pedido;
DELIMITER //

CREATE TRIGGER trigger_actualizar_estado_pedido
AFTER UPDATE ON Detalle_Pedido
FOR EACH ROW
BEGIN
    DECLARE detalles_incompletos INT;

    -- Contar si hay algún detalle de pedido que no esté completado para el mismo pedido
    SELECT COUNT(*)
    INTO detalles_incompletos
    FROM Detalle_Pedido
    WHERE ID_Pedido = NEW.ID_Pedido AND Estado <> 'Completado';

    -- Si no hay detalles pendientes, actualizar el estado del pedido a 'Completado'
    IF detalles_incompletos = 0 THEN
        UPDATE Pedidos
        SET Estado = 'Completado'
        WHERE ID_Pedido = NEW.ID_Pedido;
    END IF;
END //

DELIMITER ;

-- ingresar stock desde un pedido recibido
DROP TRIGGER IF EXISTS trigger_registrar_ingreso_inventario;
DELIMITER //

CREATE TRIGGER trigger_registrar_ingreso_inventario
AFTER UPDATE ON Detalle_Pedido
FOR EACH ROW
BEGIN
    -- Verificar si el estado del detalle de pedido cambió a 'Completado'
    IF NEW.Estado = 'Completado' AND OLD.Estado <> 'Completado' THEN
        -- Insertar una nueva entrada en el inventario para el material recibido
        INSERT INTO Inventario (ID_Material, Cantidad_Disponible, ID_Ubicacion, Fecha_Ingreso)
        VALUES (NEW.ID_Material, NEW.Cantidad, NEW.ID_Ubicacion, NOW());
    END IF;
END //

DELIMITER ;
