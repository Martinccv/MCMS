USE MCMS;

SET GLOBAL local_infile = true;

-- Datos para la tabla Ubicaciones
INSERT INTO Ubicaciones (Nombre, Direccion, Encargado) VALUES
('Almacén Central', 'Calle Principal 123', 'Juan Pérez'),
('Depósito Norte', 'Avenida Norte 456', 'María López'),
('Sede Sur', 'Calle Sur 789', 'Carlos Torres');

-- Datos para la tabla Proveedores
INSERT INTO Proveedores (Nombre, Contacto, Direccion, Telefono, Correo) VALUES
('Proveedor A', 'Ana Sánchez', 'Avenida Proveedores 101', '123456789', 'proveedora@example.com'),
('Proveedor B', 'Luis García', 'Calle Abastecedores 202', '987654321', 'proveedorb@example.com');

-- Datos para la tabla Materiales
INSERT INTO Materiales (Nombre, Descripcion, ID_Proveedor, Unidad_Medida) VALUES
('Tornillo', 'Tornillo de acero inoxidable', 1, 'unidad'),
('Madera', 'Madera de pino', 2, 'metro cúbico'),
('Pintura', 'Pintura para interiores, color blanco', 1, 'litro');

-- Datos para la tabla Activos
INSERT INTO Activos (Tipo, Descripcion, Fecha_Compra, Proveedor, Valor, ID_Ubicacion, Estado) VALUES
('Camión', 'Camión de carga', '2023-01-15', 'Proveedor A', 50000.00, 1, 'Activo'),
('Grua', 'Grua hidráulica', '2022-06-20', 'Proveedor B', 75000.00, 2, 'Activo'),
('Compresor', 'Compresor de aire industrial', '2023-02-28', 'Proveedor A', 12000.00, 1, 'En Reparación');

-- Datos para la tabla Historial_Activo
INSERT INTO Historial_Activo (ID_Activo, Fecha, Descripcion, Costo, Responsable) VALUES
(1, '2023-05-10', 'Mantenimiento general', 500.00, 'Pedro Gomez'),
(2, '2023-06-15', 'Cambio de aceite', 250.00, 'Luis Sánchez'),
(3, '2023-07-20', 'Reparación de pistón', 800.00, 'Carla Pérez');

-- Datos para la tabla Inventario
INSERT INTO Inventario (ID_Material, Cantidad_Disponible, ID_Ubicacion) VALUES
(1, 100, 1),
(2, 70, 1),
(3, 200, 2);

-- Datos para la tabla Ordenes_Mantenimiento
INSERT INTO Ordenes_Mantenimiento (ID_Activo, Tipo_Mantenimiento, Fecha_Inicio, Fecha_Fin, Estado, Descripcion) VALUES
(1, 'Preventivo', '2023-08-01', '2023-08-02', 'Completado', 'Revisión de sistema de frenos'),
(2, 'Correctivo', '2023-08-10', NULL, 'En Proceso', 'Reparación del sistema hidráulico'),
(3, 'Preventivo', '2023-09-15', '2023-09-16', 'Pendiente', 'Cambio de filtros de aire');

-- Datos para la tabla Programacion_Mantenimiento
INSERT INTO Programacion_Mantenimiento (ID_Activo, Frecuencia, Proxima_Fecha) VALUES
(1, 'Mensual', '2023-10-01'),
(2, 'Anual', '2024-08-10'),
(3, 'Semanal', '2023-09-22');

-- Datos para la tabla Tareas
INSERT INTO Tareas (ID_Orden, Descripcion, Estado, Responsable) VALUES
(1, 'Revisión de frenos', 'Completada', 'Pedro Gómez'),
(2, 'Reparación hidráulica', 'En Proceso', 'María Torres'),
(3, 'Cambio de filtros de aire', 'Pendiente', 'Luis García');

-- Datos para la tabla Pedidos
INSERT INTO Pedidos (ID_Proveedor, Fecha_Pedido, Estado, Total) VALUES
(1, '2023-08-05', 'Pendiente', 500.00),
(2, '2023-09-10', 'Recibido', 1000.00);

-- Datos para la tabla Detalle_Pedido
INSERT INTO Detalle_Pedido (ID_Pedido, ID_Material, Cantidad, Costo) VALUES
(1, 1, 100, 50.00),
(1, 2, 10, 150.00),
(2, 3, 40, 25.00);

-- Datos para la tabla Recepciones
INSERT INTO Recepciones (ID_Pedido, Fecha_Recepcion, Estado) VALUES
(2, '2023-09-15', 'Completada');
