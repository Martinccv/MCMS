-- Modulo: Mantenimiento correctivo y preventivo

CREATE TABLE Ordenes_Mantenimiento (
    ID_Orden INT PRIMARY KEY AUTO_INCREMENT,
    ID_Activo INT,
    Tipo_Mantenimiento ENUM('Preventivo', 'Correctivo') NOT NULL,
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    Estado ENUM('Pendiente', 'En Proceso', 'Completado') DEFAULT 'Pendiente',
    Descripcion TEXT
);

CREATE TABLE Programacion_Mantenimiento (
    ID_Programacion INT PRIMARY KEY AUTO_INCREMENT,
    ID_Activo INT,
    Frecuencia ENUM('Diaria', 'Semanal', 'Mensual', 'Anual'),
    Proxima_Fecha DATE
);

CREATE TABLE Tareas (
    ID_Tarea INT PRIMARY KEY AUTO_INCREMENT,
    ID_Orden INT,
    Descripcion TEXT,
    Estado ENUM('Pendiente', 'En Proceso', 'Completada') DEFAULT 'Pendiente',
    Responsable VARCHAR(100)
);

-- Claves foráneas
ALTER TABLE Ordenes_Mantenimiento
    ADD FOREIGN KEY (ID_Activo) REFERENCES Activos(ID_Activo);

ALTER TABLE Programacion_Mantenimiento
    ADD FOREIGN KEY (ID_Activo) REFERENCES Activos(ID_Activo);

ALTER TABLE Tareas
    ADD FOREIGN KEY (ID_Orden) REFERENCES Ordenes_Mantenimiento(ID_Orden);
