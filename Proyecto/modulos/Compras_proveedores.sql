-- Modulo: Compras y proveedores

CREATE TABLE Pedidos (
    ID_Pedido INT PRIMARY KEY AUTO_INCREMENT,
    ID_Proveedor INT,
    Fecha_Pedido DATE,
    Estado ENUM('Pendiente', 'Recibido') DEFAULT 'Pendiente',
    Total DECIMAL(10, 2)
);

CREATE TABLE Detalle_Pedido (
    ID_Detalle INT PRIMARY KEY AUTO_INCREMENT,
    ID_Pedido INT,
    ID_Material INT,
    Cantidad INT,
    Costo DECIMAL(10, 2),
    Estado ENUM('Pendiente', 'Recibido') DEFAULT 'Pendiente',
    ID_Ubicacion INT DEFAULT 1
);

CREATE TABLE Recepciones (
    ID_Recepcion INT PRIMARY KEY AUTO_INCREMENT,
    ID_Pedido INT,
    Fecha_Recepcion DATE,
    Estado ENUM('Pendiente', 'Completada') DEFAULT 'Pendiente',
    ID_Ubicacion INT DEFAULT 1
);

-- Claves foráneas
ALTER TABLE Pedidos
    ADD FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor);

ALTER TABLE Detalle_Pedido
    ADD FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    ADD FOREIGN KEY (ID_Material) REFERENCES Materiales(ID_Material),
    ADD FOREIGN KEY (ID_Ubicacion) REFERENCES Ubicaciones(ID_Ubicacion);

ALTER TABLE Recepciones
    ADD FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    ADD FOREIGN KEY (ID_Ubicacion) REFERENCES Ubicaciones(ID_Ubicacion);
