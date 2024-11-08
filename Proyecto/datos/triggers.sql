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

-- Trigger para alertar cuando el inventario está bajo el mínimo:
DROP TRIGGER IF EXISTS trigger_inventario_minimo;
DELIMITER //
CREATE TRIGGER trigger_inventario_minimo
AFTER UPDATE ON Inventario
FOR EACH ROW
BEGIN
    IF NEW.Cantidad_Disponible < NEW.Cantidad_Minima THEN
        INSERT INTO Alertas (Mensaje, Fecha) VALUES (CONCAT('Stock bajo para material ID ', NEW.ID_Material), NOW());
    END IF;
END//
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