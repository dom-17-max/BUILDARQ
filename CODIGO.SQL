DROP DATABASE IF EXISTS BUILDARQ;
CREATE DATABASE BUILDARQ;
USE BUILDARQ;

-- Tabla de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ruc_ci VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    direccion VARCHAR(255),
    telefono VARCHAR(20)
);

-- Tabla de proyectos
CREATE TABLE proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    presupuesto DECIMAL(12,2) CHECK (presupuesto >= 0),
    cliente_id INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabla de empleados
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    salario DECIMAL(10,2) CHECK (salario >= 0)
);

-- Tabla de asignaciones (empleados en proyectos)
CREATE TABLE asignaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proyecto_id INT,
    empleado_id INT,
    rol VARCHAR(100),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id) ON DELETE CASCADE
);

-- Tabla de materiales
CREATE TABLE materiales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad VARCHAR(50),
    precio_unitario DECIMAL(10,2) CHECK (precio_unitario >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0)
);

-- Tabla de uso de materiales en proyectos
CREATE TABLE uso_materiales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proyecto_id INT,
    material_id INT,
    cantidad INT CHECK (cantidad > 0),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES materiales(id)
);

DELIMITER $$

-- Procedimiento para insertar cliente con validación
CREATE PROCEDURE sp_insert_cliente(
    IN p_nombre VARCHAR(100),
    IN p_ruc_ci VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(255),
    IN p_telefono VARCHAR(20)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count FROM clientes WHERE ruc_ci = p_ruc_ci;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RUC/C.I. ya existe';
    END IF;

    INSERT INTO clientes(nombre, ruc_ci, email, direccion, telefono)
    VALUES (p_nombre, p_ruc_ci, p_email, p_direccion, p_telefono);
END$$

-- Procedimiento para insertar proyecto
CREATE PROCEDURE sp_insert_proyecto(
    IN p_nombre VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_presupuesto DECIMAL(12,2),
    IN p_cliente_id INT
)
BEGIN
    IF p_presupuesto < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Presupuesto inválido';
    END IF;

    INSERT INTO proyectos(nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, cliente_id)
    VALUES (p_nombre, p_descripcion, p_fecha_inicio, p_fecha_fin, p_presupuesto, p_cliente_id);
END$$

-- Procedimiento para asignar empleado a proyecto
CREATE PROCEDURE sp_asignar_empleado(
    IN p_proyecto_id INT,
    IN p_empleado_id INT,
    IN p_rol VARCHAR(100)
)
BEGIN
    INSERT INTO asignaciones(proyecto_id, empleado_id, rol)
    VALUES (p_proyecto_id, p_empleado_id, p_rol);
END$$

-- Procedimiento para registrar uso de materiales
CREATE PROCEDURE sp_usar_material(
    IN p_proyecto_id INT,
    IN p_material_id INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_stock INT;

    SELECT stock INTO v_stock FROM materiales WHERE id = p_material_id;

    IF v_stock < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    UPDATE materiales SET stock = stock - p_cantidad WHERE id = p_material_id;

    INSERT INTO uso_materiales(proyecto_id, material_id, cantidad)
    VALUES (p_proyecto_id, p_material_id, p_cantidad);
END$$

DELIMITER ;

-- Datos de prueba
INSERT INTO clientes(nombre, ruc_ci, email, direccion, telefono)
VALUES 
('Constructora Andes', '1790012345001', 'contacto@andes.com', 'Av. Quito 101', '0999999999'),
('Inmobiliaria El Sol', '0991234567', 'info@elsol.com', 'Calle Bolívar 202', '0988888888');

INSERT INTO empleados(nombre, cargo, salario)
VALUES
('Juan Pérez', 'Ingeniero Civil', 1200.00),
('Ana Torres', 'Arquitecta', 1500.00),
('Luis Gómez', 'Obrero', 600.00);

INSERT INTO materiales(nombre, unidad, precio_unitario, stock)
VALUES
('Cemento', 'Sacos', 8.50, 500),
('Varilla de acero', 'Unidades', 12.00, 300),
('Arena', 'm3', 15.00, 200);

CALL sp_insert_proyecto('Edificio Central', 'Construcción de edificio de oficinas', '2025-01-10', '2025-12-20', 500000, 1);
CALL sp_insert_proyecto('Urbanización Sol Naciente', 'Construcción de casas', '2025-02-01', '2026-06-15', 1200000, 2);

CALL sp_asignar_empleado(1, 1, 'Supervisor');
CALL sp_asignar_empleado(1, 2, 'Diseñadora');
CALL sp_asignar_empleado(2, 3, 'Obrero');

CALL sp_usar_material(1, 1, 50); -- 50 sacos de cemento en Edificio Central
CALL sp_usar_material(1, 2, 20); -- 20 varillas
CALL sp_usar_material(2, 3, 30); -- 30 m3 de arena en Urbanización

-- Reportes

-- 1. Listar proyectos con su cliente
SELECT p.id, p.nombre AS proyecto, c.nombre AS cliente, p.presupuesto, p.fecha_inicio, p.fecha_fin
FROM proyectos p
JOIN clientes c ON p.cliente_id = c.id;

-- 2. Empleados asignados a cada proyecto
SELECT pr.nombre AS proyecto, e.nombre AS empleado, a.rol
FROM asignaciones a
JOIN proyectos pr ON a.proyecto_id = pr.id
JOIN empleados e ON a.empleado_id = e.id;

-- 3. Materiales usados por proyecto
SELECT pr.nombre AS proyecto, m.nombre AS material, um.cantidad
FROM uso_materiales um
JOIN proyectos pr ON um.proyecto_id = pr.id
JOIN materiales m ON um.material_id = m.id;

-- 4. Proyectos con mayor presupuesto
SELECT nombre, presupuesto
FROM proyectos
ORDER BY presupuesto DESC;

