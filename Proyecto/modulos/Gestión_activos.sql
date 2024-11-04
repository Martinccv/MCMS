-- Modulo: Gestión de activos

CREATE TABLE Ubicaciones (
    ID_Ubicacion INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(150),
    Encargado VARCHAR(100)
);

CREATE TABLE Activos (
    ID_Activo INT PRIMARY KEY AUTO_INCREMENT,
    Tipo VARCHAR(50) NOT NULL,
    Descripcion TEXT,
    Fecha_Compra DATE,
    Proveedor VARCHAR(100),
    Valor DECIMAL(10, 2),
    ID_Ubicacion INT,
    Estado ENUM('Activo', 'En Reparación', 'Dado de Baja') DEFAULT 'Activo'
);

CREATE TABLE Historial_Activo (
    ID_Historial INT PRIMARY KEY AUTO_INCREMENT,
    ID_Activo INT,
    Fecha DATE,
    Descripcion TEXT,
    Costo DECIMAL(10, 2),
    Responsable VARCHAR(100)
);

-- Claves foráneas
ALTER TABLE Activos
    ADD FOREIGN KEY (ID_Ubicacion) REFERENCES Ubicaciones(ID_Ubicacion);

ALTER TABLE Historial_Activo
    ADD FOREIGN KEY (ID_Activo) REFERENCES Activos(ID_Activo);
