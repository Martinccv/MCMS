DROP DATABASE IF EXISTS MCMS;
CREATE DATABASE MCMS;
USE MCMS;

SOURCE ./Proyecto/modulos/Gestión_activos.sql;
SOURCE ./Proyecto/modulos/Inventario_almacen.sql;
SOURCE ./Proyecto/modulos/Compras_proveedores.sql;
SOURCE ./Proyecto/modulos/Mantenimiento.sql;

SELECT 'Estructura y datos cargados exitosamente en la base de datos gestion_mantenimiento';
