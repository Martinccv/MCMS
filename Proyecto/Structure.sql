DROP DATABASE IF EXISTS MCMS;
CREATE DATABASE MCMS;
USE MCMS;

SOURCE ./modulos/Gestión_activos.sql;
SOURCE ./modulos/Inventario_almacen.sql;
SOURCE ./modulos/Compras_proveedores.sql;
SOURCE ./modulos/Mantenimiento.sql;
SOURCE ./datos/data.sql;

SELECT 'Estructura y datos cargados exitosamente en la base de datos gestion_mantenimiento';
