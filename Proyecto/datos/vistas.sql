USE MCMS;

-- Vista para ver el inventario general de materiales por ubicación
DROP VIEW IF EXISTS Vista_Inventario_Materiales;
CREATE VIEW Vista_Inventario_Materiales AS
SELECT 
    u.Nombre AS Ubicacion,
    m.Nombre AS Material,
    SUM(i.Cantidad_Disponible) AS Cantidad_Total_Disponible
FROM Inventario i
JOIN Materiales m ON i.ID_Material = m.ID_Material
JOIN Ubicaciones u ON i.ID_Ubicacion = u.ID_Ubicacion
GROUP BY u.Nombre, m.Nombre;


-- Vista para obtener el estado de las órdenes de mantenimiento de los activos
DROP VIEW IF EXISTS Vista_Estado_Mantenimiento;
CREATE VIEW Vista_Estado_Mantenimiento AS
SELECT a.Descripcion AS Activo,
       o.Tipo_Mantenimiento,
       o.Fecha_Inicio,
       o.Fecha_Fin,
       o.Estado
FROM Ordenes_Mantenimiento o
JOIN Activos a ON o.ID_Activo = a.ID_Activo;

-- Vista para ver el estado de los pedidos de materiales
DROP VIEW IF EXISTS Vista_Estado_Pedidos;
CREATE VIEW Vista_Estado_Pedidos AS
SELECT p.ID_Pedido,
       p.Fecha_Pedido,
       p.Estado,
       SUM(dp.Costo * dp.Cantidad) AS Total_Costo
FROM Pedidos p
JOIN Detalle_Pedido dp ON p.ID_Pedido = dp.ID_Pedido
GROUP BY p.ID_Pedido, p.Fecha_Pedido, p.Estado;
