USE MCMS;

DROP ROLE IF EXISTS Mantenimiento_Jefe, Mantenimiento_Tecnico, Inventario_Gerente, Inventario_Empleado, Compras_Responsable, Analista;
-- Rol para Jefe de Mantenimiento
CREATE ROLE Mantenimiento_Jefe;
GRANT SELECT, INSERT, UPDATE, DELETE ON Ordenes_Mantenimiento TO Mantenimiento_Jefe;
GRANT SELECT, INSERT, UPDATE, DELETE ON Programacion_Mantenimiento TO Mantenimiento_Jefe;
GRANT SELECT, INSERT, UPDATE, DELETE ON Tareas TO Mantenimiento_Jefe;
GRANT EXECUTE ON PROCEDURE sp_actualizar_estado_activo TO Mantenimiento_Jefe;

-- Rol para Técnico de Mantenimiento
CREATE ROLE Mantenimiento_Tecnico;
GRANT SELECT, UPDATE ON Tareas TO Mantenimiento_Tecnico;

-- Rol para Gerente de Inventario
CREATE ROLE Inventario_Gerente;
GRANT ALL PRIVILEGES ON Inventario TO Inventario_Gerente;
GRANT SELECT ON Vista_Inventario_Materiales TO Inventario_Gerente;

-- Rol para Empleado de Inventario
CREATE ROLE Inventario_Empleado;
GRANT SELECT, UPDATE ON Inventario TO Inventario_Empleado;
GRANT SELECT, INSERT ON Pedidos TO Inventario_Empleado;

-- Rol para Responsable de Compras
CREATE ROLE Compras_Responsable;
GRANT SELECT, INSERT, UPDATE, DELETE ON Proveedores TO Compras_Responsable;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pedidos TO Compras_Responsable;
GRANT SELECT, INSERT, UPDATE, DELETE ON Detalle_Pedido TO Compras_Responsable;
GRANT SELECT, INSERT, UPDATE, DELETE ON Recepciones TO Compras_Responsable;
GRANT EXECUTE ON PROCEDURE sp_generar_pedido TO Compras_Responsable;

-- Rol para Analista de Reportes
CREATE ROLE Analista;
GRANT SELECT ON Activos TO Analista;
GRANT SELECT ON Inventario TO Analista;
GRANT SELECT ON Ordenes_Mantenimiento TO Analista;
GRANT SELECT ON Programacion_Mantenimiento TO Analista;
GRANT SELECT ON Proveedores TO Analista;
GRANT SELECT ON Tareas TO Analista;
GRANT SELECT ON Vista_Estado_Mantenimiento TO Analista;
GRANT SELECT ON Vista_Estado_Pedidos TO Analista;
GRANT SELECT ON Vista_Inventario_Materiales TO Analista;

DROP USER IF EXISTS jefe_mantenimiento, tecnico_mantenimiento, gerente_inventario, empleado_inventario, responsable_compras, analista;
-- Creación de usuarios y asignación de roles
CREATE USER 'jefe_mantenimiento'@'%' IDENTIFIED BY 'password';
GRANT Mantenimiento_Jefe TO 'jefe_mantenimiento'@'%';

CREATE USER 'tecnico_mantenimiento'@'%' IDENTIFIED BY 'password';
GRANT Mantenimiento_Tecnico TO 'tecnico_mantenimiento'@'%';

CREATE USER 'gerente_inventario'@'%' IDENTIFIED BY 'password';
GRANT Inventario_Gerente TO 'gerente_inventario'@'%';

CREATE USER 'empleado_inventario'@'%' IDENTIFIED BY 'password';
GRANT Inventario_Empleado TO 'empleado_inventario'@'%';

CREATE USER 'responsable_compras'@'%' IDENTIFIED BY 'password';
GRANT Compras_Responsable TO 'responsable_compras'@'%';

CREATE USER 'analista'@'%' IDENTIFIED BY 'password';
GRANT Analista TO 'analista'@'%';

FLUSH PRIVILEGES;

