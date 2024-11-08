USE MCMS;

-- Función para verificar la cantidad disponible de un material en una ubicación específica
DROP FUNCTION IF EXISTS verificar_disponibilidad_material;
DELIMITER //

CREATE FUNCTION verificar_disponibilidad_material(
    p_material_id INT,
    p_ubicacion_id INT
) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT IFNULL(Cantidad_Disponible, 0)
        FROM Inventario
        WHERE ID_Material = p_material_id AND ID_Ubicacion = p_ubicacion_id
    );
END //

DELIMITER ;

-- Función para calcular el costo total de mantenimiento de un activo
DROP FUNCTION IF EXISTS calcular_costo_mantenimiento;
DELIMITER //

CREATE FUNCTION calcular_costo_mantenimiento(
    p_activo_id INT
) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2) DEFAULT 0;
    
    -- Utilizamos SELECT INTO para asignar el valor a la variable
    SELECT IFNULL(SUM(Costo), 0) INTO total
    FROM Historial_Activo
    WHERE ID_Activo = p_activo_id;

    RETURN total;
END //
DELIMITER ;

