-- Modulo: Inventario y almacenes

CREATE TABLE Proveedores (
    ID_Proveedor INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Contacto VARCHAR(50),
    Direccion VARCHAR(150),
    Telefono VARCHAR(20),
    Correo VARCHAR(100)
);

CREATE TABLE Materiales (
    ID_Material INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    ID_Proveedor INT,
    Unidad_Medida VARCHAR(20)
);

CREATE TABLE Inventario (
    ID_Inventario INT PRIMARY KEY AUTO_INCREMENT,
    ID_Material INT,
    Cantidad_Disponible INT,
    Cantidad_Minima INT,
    ID_Ubicacion INT
);

CREATE TABLE Alertas (
    ID_Alerta INT PRIMARY KEY AUTO_INCREMENT,
    Mensaje VARCHAR(255) NOT NULL,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    Estado ENUM('Pendiente', 'Atendida') DEFAULT 'Pendiente'
);

-- Claves foráneas
ALTER TABLE Materiales
    ADD FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor);

ALTER TABLE Inventario
    ADD FOREIGN KEY (ID_Material) REFERENCES Materiales(ID_Material),
    ADD FOREIGN KEY (ID_Ubicacion) REFERENCES Ubicaciones(ID_Ubicacion);
