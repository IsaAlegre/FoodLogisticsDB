/*
	Trabajo Practico 2 Base de datos
    Alumnos: Alegre Isabella, Becerra Tobias, Benitez Lucia, Klikailo Anahi.
    Este archivo ya contiene tanto la creacion de la base de datos, sus tablas, la insercion de los datos y las consultas realizadas. 
*/

-- 3. Creacion de la base de datos

DROP DATABASE IF EXISTS TP2;
CREATE DATABASE TP2;

USE TP2;

CREATE TABLE repartidor (
	idRepartidor	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre			VARCHAR(32),
	apellido		VARCHAR(32),
	telefono		VARCHAR(16),
	turnoAlta		TIMESTAMP,
	turnoBaja		TIMESTAMP
);

CREATE TABLE medioTransporte (
	idMedioTransporte	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre			VARCHAR(32),
	idRepartidor		INT NOT NULL,
	patente			VARCHAR(7),
	FOREIGN KEY(idRepartidor) references repartidor(idRepartidor),
	estaActivo		TINYINT(1)
);



CREATE TABLE usuario (
	idUsuario		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre			VARCHAR(32),
	apellido		VARCHAR(32),
	correo			VARCHAR(255),
	telefono		VARCHAR(16),
	direccion		VARCHAR(32),
	fechaAlta		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja		TIMESTAMP
);

CREATE TABLE categoria (
	idCategoria		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombreCategoria		VARCHAR(32),
	fechaAlta		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja		TIMESTAMP
);


CREATE TABLE local(
	idLocal			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombreLocal		VARCHAR(32),
	idCategoria		INT NOT NULL,
	FOREIGN KEY(idCategoria) references categoria(idCategoria),
	fechaAlta		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja		TIMESTAMP
);

CREATE TABLE producto (
	idProducto			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre				VARCHAR(32),
	precio				FLOAT(3),
	stock				INT,
	fechaAlta			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja			TIMESTAMP,
	vencimiento			TIMESTAMP,
	idLocal				INT NOT NULL,
	FOREIGN KEY(idLocal) references local(idLocal)
);

CREATE TABLE resenia (
	idResenia			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idUsuario			INT NOT NULL,
	FOREIGN KEY(idUsuario) references usuario(idUsuario),
	idRepatidor			INT NOT NULL,
	FOREIGN KEY(idRepatidor) references repartidor(idRepartidor),
	idLocal				INT NOT NULL,
	FOREIGN KEY(idLocal) references local(idLocal),
	calificacion			DECIMAL(2,1),
	comentario			TEXT,
	fechaAlta			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	estaActivo			TINYINT(1)
);


CREATE TABLE estadoPedido (
	idEstadoPedido		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	descripcion			TEXT,
	fechaAlta			TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE metodoPago (
	idMetodoPago	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tipoPago		VARCHAR(32),
	fechaAlta		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja		TIMESTAMP
);

CREATE TABLE pago (
	idPago			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	monto			FLOAT(3),
	idMetodoPago	INT NOT NULL,
	FOREIGN KEY(idMetodoPago) references metodoPago(idMetodoPago),
	fechaAlta		TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historialPromociones (
	idHistorialPromociones	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idLocal				    INT NOT NULL,
	FOREIGN KEY(idLocal) references local(idLocal),
	fechaAlta			    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja			    TIMESTAMP
);

CREATE TABLE promocion (
	idPromocion			    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idHistorialPromociones	INT NOT NULL,
	FOREIGN KEY(idHistorialPromociones) references historialPromociones(idHistorialPromociones),
	nombrePromocion		    VARCHAR(32),
	descontar			    FLOAT(3),
	estado				    TINYINT(1),
	fechaAlta			    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fechaBaja			    TIMESTAMP
);

CREATE TABLE pedido (
	idPedido			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idPago			 	INT NOT NULL,
	FOREIGN KEY(idPago) references pago(idPago),
	idEstadoPedido		INT NOT NULL,
	FOREIGN KEY(idEstadoPedido) references estadoPedido(idEstadoPedido),
	idRepartidor		INT NOT NULL,
	FOREIGN KEY(idRepartidor) references repartidor(idRepartidor),
	idPromocion			INT NULL,
	FOREIGN KEY(idPromocion) references promocion(idPromocion),
	idUsuario		 	INT NOT NULL,
	FOREIGN KEY(idUsuario) references usuario(idUsuario),
	fechaAlta			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	totalFinal			FLOAT(3),
	descuentoAplicado	FLOAT(3)
);


CREATE TABLE detallePedido (
	idDetallePedido			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idPedido				INT NOT NULL,
	FOREIGN KEY(idPedido) references pedido(idPedido),
	idProducto				INT NOT NULL,
	FOREIGN KEY(idProducto) references producto(idProducto),
	cantidadProducto		INT
);

-- 4. Restricciones CHECK
ALTER TABLE usuario
ADD CONSTRAINT CHK_correo CHECK (correo LIKE '%@%'); -- Asegurar que se ingrese una direccion de correo


ALTER TABLE resenia
ADD CONSTRAINT CHK_calificacion CHECK (calificacion > 0.0 AND calificacion <= 5.0); -- Asegurar que la calificacion se encuentre dentro del rango 0.1 - 5.0

-- 5. Carga de Datos

-- Categorias
-- Decidimos no poner tantas categorias ya que en las APPs de delivery no coinciden tantas

INSERT INTO categoria (nombreCategoria, fechaAlta) VALUES
('Pizzería', '2024-12-15 10:00:00'),
('Hamburguesas', '2024-12-15 10:00:00'),
('Sushi', '2024-12-15 10:00:00'),
('Comida Mexicana', '2024-12-15 10:00:00'),
('Pastas', '2024-12-15 10:00:00'),
('Parrilla', '2024-12-15 10:00:00'),
('Comida China', '2024-12-15 10:00:00'),
('Cafetería', '2024-12-15 10:00:00');

-- Metodos de Pago 
-- Decidimos no poner tantas categorias ya que en las APPs de delivery no coinciden tantas

INSERT INTO metodoPago (tipoPago, fechaAlta) VALUES
('Efectivo', '2024-12-20 09:00:00'),
('Tarjeta de Débito', '2024-12-20 09:00:00'),
('Tarjeta de Crédito', '2024-12-20 09:00:00'),
('MercadoPago', '2024-12-20 09:00:00'),
('Transferencia Bancaria', '2024-12-20 09:00:00');

-- Estados de Pedido
-- Decidimos no poner tantos estados ya que en las APPs de delivery no coinciden tantas

INSERT INTO estadoPedido (descripcion, fechaAlta) VALUES
('Pendiente', '2024-12-20 09:30:00'),
('Preparando', '2024-12-20 09:30:00'),
('En Camino', '2024-12-20 09:30:00'),
('Entregado', '2024-12-20 09:30:00'),
('Cancelado', '2024-12-20 09:30:00'),
('Devuelto', '2024-12-20 09:30:00');

-- Repartidores 

INSERT INTO repartidor (nombre, apellido, telefono, turnoAlta) VALUES
('Ezreal', 'Lymere', '1145678901', '2025-01-05 08:00:00'),
('Jinx', 'Powder', '1145678902', '2025-01-05 08:00:00'),
('Yasuo', 'Ioniano', '1145678903', '2025-01-06 08:00:00'),
('Ahri', 'Vastaya', '1145678904', '2025-01-06 08:00:00'),
('Zed', 'Sombra', '1145678905', '2025-01-07 08:00:00'),
('Lux', 'Crownguard', '1145678906', '2025-01-07 08:00:00'),
('Vayne', 'Night', '1145678907', '2025-01-08 08:00:00'),
('Thresh', 'Chain', '1145678908', '2025-01-08 08:00:00'),
('Ekko', 'Time', '1145678909', '2025-01-09 08:00:00'),
('Vi', 'Enforcer', '1145678910', '2025-01-09 08:00:00'),
('Katarina', 'Du Couteau', '1145678911', '2025-01-10 08:00:00'),
('Darius', 'Noxus', '1145678912', '2025-01-10 08:00:00'),
('Jhin', 'Virtuoso', '1145678913', '2025-01-11 08:00:00'),
('Senna', 'Sentinel', '1145678914', '2025-01-11 08:00:00'),
('Akali', 'Kinkou', '1145678915', '2025-01-12 08:00:00'),
('Pyke', 'Ripper', '1145678916', '2025-01-12 08:00:00'),
('Yone', 'Azakana', '1145678917', '2025-01-13 08:00:00'),
('Kai Sa', 'Void', '1145678918', '2025-01-13 08:00:00'),
('Teemo', 'Scout', '1145678919', '2025-01-14 08:00:00'),
('Twisted Fate', 'Cartas', '1145678920', '2025-01-14 08:00:00'),
('Gangplank', 'Pirate', '1145678921', '2025-01-15 08:00:00'),
('Rengar', 'Hunter', '1145678922', '2025-01-15 08:00:00'),
('Kha Zix', 'Void', '1145678923', '2025-01-16 08:00:00'),
('Shen', 'Eye', '1145678924', '2025-01-16 08:00:00'),
('Rammus', 'Armadillo', '1145678925', '2025-01-17 08:00:00'),
('Shaco', 'Jester', '1145678926', '2025-01-17 08:00:00'),
('Singed', 'Chemist', '1145678927', '2025-01-18 08:00:00'),
('Tryndamere', 'King', '1145678928', '2025-01-18 08:00:00'),
('Volibear', 'Thunder', '1145678929', '2025-01-19 08:00:00'),
('Warwick', 'Wolf', '1145678930', '2025-01-19 08:00:00');

-- Medios de Transporte 

INSERT INTO medioTransporte (nombre, idRepartidor, patente, estaActivo) VALUES
('Moto Honda', 1, 'ABC123', 1),
('Moto Yamaha', 2, 'DEF456', 1),
('Bicicleta', 3, 'GHI789', 1),
('Moto Suzuki', 4, 'JKL012', 1),
('Auto Corolla', 5, 'MNO345', 1),
('Moto Honda', 6, 'PQR678', 1),
('Bicicleta', 7, 'STU901', 1),
('Moto Kawasaki', 8, 'VWX234', 1),
('Moto Yamaha', 9, 'YZA567', 1),
('Auto Focus', 10, 'BCD890', 1),
('Moto Honda', 11, 'EFG123', 1),
('Moto Suzuki', 12, 'HIJ456', 1),
('Bicicleta', 13, 'KLM789', 1),
('Moto Yamaha', 14, 'NOP012', 1),
('Moto Honda', 15, 'QRS345', 1),
('Bicicleta', 16, 'TUV678', 1),
('Moto Kawasaki', 17, 'WXY901', 1),
('Moto Suzuki', 18, 'ZAB234', 1),
('Moto Honda', 19, 'CDE567', 1),
('Bicicleta', 20, 'FGH890', 1),
('Moto Yamaha', 21, 'IJK123', 1),
('Moto Suzuki', 22, 'LMN456', 1),
('Moto Kawasaki', 23, 'OPQ789', 1),
('Auto Civic', 24, 'RST012', 1),
('Moto Honda', 25, 'UVW345', 1),
('Bicicleta', 26, 'XYZ678', 1),
('Moto Yamaha', 27, 'AAB901', 1),
('Moto Suzuki', 28, 'CCD234', 1),
('Auto Gol', 29, 'EEF567', 1),
('Moto Kawasaki', 30, 'GGH890', 1);

-- Usuarios

INSERT INTO usuario (nombre, apellido, correo, telefono, direccion, fechaAlta) VALUES
('Garen', 'Crownguard', 'garen@demacia.com', '1156781001', 'Av. Demacia 100', '2025-01-10 10:00:00'),
('Ashe', 'Freljord', 'ashe@freljord.com', '1156781002', 'Calle Hielo 200', '2025-01-11 10:00:00'),
('Lee Sin', 'Monje', 'leesin@ionia.com', '1156781003', 'Templo 300', '2025-01-12 10:00:00'),
('Annie', 'Hastur', 'annie@noxus.com', '1156781004', 'Calle Fuego 400', '2025-01-13 10:00:00'),
('Blitzcrank', 'Robot', 'blitz@zaun.com', '1156781005', 'Distrito Zaun 500', '2025-01-14 10:00:00'),
('Caitlyn', 'Sheriff', 'caitlyn@piltover.com', '1156781006', 'Plaza Piltover 600', '2025-01-15 10:00:00'),
('Draven', 'Glory', 'draven@noxus.com', '1156781007', 'Arena 700', '2025-01-16 10:00:00'),
('Elise', 'Spider', 'elise@shadow.com', '1156781008', 'Islas Sombra 800', '2025-01-17 10:00:00'),
('Fiora', 'Laurent', 'fiora@demacia.com', '1156781009', 'Mansion Laurent 900', '2025-01-18 10:00:00'),
('Gragas', 'Cervecero', 'gragas@freljord.com', '1156781010', 'Taberna 1000', '2025-01-19 10:00:00'),
('Heimerdinger', 'Inventor', 'heimer@piltover.com', '1156781011', 'Laboratorio 1100', '2025-01-20 10:00:00'),
('Irelia', 'Blade', 'irelia@ionia.com', '1156781012', 'Navori 1200', '2025-01-21 10:00:00'),
('Jarvan IV', 'Prince', 'jarvan@demacia.com', '1156781013', 'Palacio Real 1300', '2025-01-22 10:00:00'),
('Karma', 'Enlightened', 'karma@ionia.com', '1156781014', 'Monasterio 1400', '2025-01-23 10:00:00'),
('Leblanc', 'Deceiver', 'leblanc@noxus.com', '1156781015', 'Rosa Negra 1500', '2025-01-24 10:00:00'),
('Malphite', 'Roca', 'malphite@ixtal.com', '1156781016', 'Montaña 1600', '2025-01-25 10:00:00'),
('Nami', 'Tidecaller', 'nami@bilgewater.com', '1156781017', 'Puerto 1700', '2025-01-26 10:00:00'),
('Orianna', 'Clockwork', 'orianna@piltover.com', '1156781018', 'Torre Reloj 1800', '2025-01-27 10:00:00'),
('Pantheon', 'Warrior', 'pantheon@targon.com', '1156781019', 'Monte Targon 1900', '2025-01-28 10:00:00'),
('Quinn', 'Ranger', 'quinn@demacia.com', '1156781020', 'Frontera 2000', '2025-01-29 10:00:00'),
('Riven', 'Exiled', 'riven@noxus.com', '1156781021', 'Exilio 2100', '2025-01-30 10:00:00'),
('Sejuani', 'Winter', 'sejuani@freljord.com', '1156781022', 'Tribu Invierno 2200', '2025-02-01 10:00:00'),
('Talon', 'Blade', 'talon@noxus.com', '1156781023', 'Callejon 2300', '2025-02-02 10:00:00'),
('Udyr', 'Spirit', 'udyr@freljord.com', '1156781024', 'Bosque 2400', '2025-02-03 10:00:00'),
('Veigar', 'Tiny', 'veigar@bandle.com', '1156781025', 'Torre Oscura 2500', '2025-02-04 10:00:00'),
('Wukong', 'Monkey', 'wukong@ionia.com', '1156781026', 'Templo Kong 2600', '2025-02-05 10:00:00'),
('Xayah', 'Rebel', 'xayah@ionia.com', '1156781027', 'Campamento 2700', '2025-02-06 10:00:00'),
('Yorick', 'Shepherd', 'yorick@shadow.com', '1156781028', 'Cementerio 2800', '2025-02-07 10:00:00'),
('Zoe', 'Aspect', 'zoe@targon.com', '1156781029', 'Portal 2900', '2025-02-08 10:00:00'),
('Braum', 'Heart', 'braum@freljord.com', '1156781030', 'Refugio 3000', '2025-02-09 10:00:00'),
('Diana', 'Moon', 'diana@targon.com', '1156781031', 'Lunari 3100', '2025-02-10 10:00:00'),
('Fizz', 'Tidal', 'fizz@bilgewater.com', '1156781032', 'Muelle 3200', '2025-02-11 10:00:00'),
('Janna', 'Wind', 'janna@zaun.com', '1156781033', 'Torres Viento 3300', '2025-02-12 10:00:00'),
('Morgana', 'Fallen', 'morgana@demacia.com', '1156781034', 'Santuario 3400', '2025-02-13 10:00:00'),
('Syndra', 'Dark', 'syndra@ionia.com', '1156781035', 'Fortaleza 3500', '2025-02-14 10:00:00');

-- Locales
-- Decidimos no agregar tantos locales porque por local agregamos 5 productos y se haria muy larga la lista.

INSERT INTO local (nombreLocal, idCategoria, fechaAlta) VALUES
('Pizzería Demacia', 1, '2025-01-05 09:00:00'),
('Burger Noxus', 2, '2025-01-05 09:00:00'),
('Sushi Ionia', 3, '2025-01-06 09:00:00'),
('Tacos Shurima', 4, '2025-01-06 09:00:00'),
('Pastas de Piltover', 5, '2025-01-07 09:00:00'),
('Parrilla Freljord', 6, '2025-01-07 09:00:00'),
('Wok de Ionia', 7, '2025-01-08 09:00:00'),
('Café Targon', 8, '2025-01-08 09:00:00'),
('Pizzería Bandle', 1, '2025-01-09 09:00:00'),
('Burger Zaun', 2, '2025-01-09 09:00:00'),
('Sushi Bilgewater', 3, '2025-01-10 09:00:00'),
('Tacos Ixtal', 4, '2025-01-10 09:00:00'),
('Pastas Demacia', 5, '2025-01-11 09:00:00'),
('Parrilla Noxus', 6, '2025-01-11 09:00:00'),
('Wok de Zaun', 7, '2025-01-12 09:00:00'),
('Café Piltover', 8, '2025-01-12 09:00:00'),
('Pizzería Void', 1, '2025-01-13 09:00:00'),
('Burger Freljord', 2, '2025-01-13 09:00:00'),
('Sushi Targon', 3, '2025-01-14 09:00:00'),
('Parrilla Shurima', 6, '2025-01-14 09:00:00');

-- Productos y sus locales

-- Pizzería Demacia 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Pizza Muzzarella', 3500, 50, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 1),
('Pizza Napolitana', 4000, 45, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 1),
('Pizza Calabresa', 4200, 40, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 1),
('Empanadas x6', 2500, 100, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 1),
('Coca Cola 1.5L', 800, 200, '2025-01-05 10:00:00', '2025-12-31 23:59:59', 1);

-- Burger Noxus 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Hamburguesa Simple', 2500, 60, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 2),
('Hamburguesa Doble', 3500, 50, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 2),
('Hamburguesa Completa', 4000, 45, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 2),
('Papas Fritas', 1500, 80, '2025-01-05 10:00:00', '2025-10-30 23:59:59', 2),
('Sprite 1.5L', 800, 150, '2025-01-05 10:00:00', '2025-12-31 23:59:59', 2);

-- Sushi Ionia 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Sushi Roll Salmón x10', 5500, 30, '2025-01-06 10:00:00', '2025-10-20 23:59:59', 3),
('Sushi Roll Atún x10', 5000, 35, '2025-01-06 10:00:00', '2025-10-20 23:59:59', 3),
('Nigiri Mix x8', 4500, 25, '2025-01-06 10:00:00', '2025-10-20 23:59:59', 3),
('Sashimi Salmón', 6000, 20, '2025-01-06 10:00:00', '2025-10-20 23:59:59', 3),
('Té Verde', 500, 100, '2025-01-06 10:00:00', '2025-12-31 23:59:59', 3);

-- Tacos Shurima 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Tacos de Carne x3', 3000, 50, '2025-01-06 10:00:00', '2025-10-25 23:59:59', 4),
('Tacos de Pollo x3', 2800, 55, '2025-01-06 10:00:00', '2025-10-25 23:59:59', 4),
('Burritos', 3500, 40, '2025-01-06 10:00:00', '2025-10-25 23:59:59', 4),
('Nachos con Queso', 2000, 70, '2025-01-06 10:00:00', '2025-10-25 23:59:59', 4),
('Agua Mineral 500ml', 600, 200, '2025-01-06 10:00:00', '2025-12-31 23:59:59', 4);

-- Pastas de Piltover 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Ravioles con Salsa', 3800, 40, '2025-01-07 10:00:00', '2025-10-28 23:59:59', 5),
('Ñoquis con Tuco', 3500, 45, '2025-01-07 10:00:00', '2025-10-28 23:59:59', 5),
('Tallarines con Crema', 4000, 35, '2025-01-07 10:00:00', '2025-10-28 23:59:59', 5),
('Lasagna', 4500, 30, '2025-01-07 10:00:00', '2025-10-28 23:59:59', 5),
('Fanta 1.5L', 800, 120, '2025-01-07 10:00:00', '2025-12-31 23:59:59', 5);

-- Parrilla Freljord 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Bife de Chorizo', 5500, 30, '2025-01-07 10:00:00', '2025-10-22 23:59:59', 6),
('Asado de Tira', 5000, 35, '2025-01-07 10:00:00', '2025-10-22 23:59:59', 6),
('Choripán', 2000, 60, '2025-01-07 10:00:00', '2025-10-22 23:59:59', 6),
('Ensalada', 1500, 50, '2025-01-07 10:00:00', '2025-10-22 23:59:59', 6),
('Quilmes 1L', 1200, 80, '2025-01-07 10:00:00', '2025-12-31 23:59:59', 6);

-- Wok de Ionia
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Arroz Chow Fan', 3200, 50, '2025-01-08 10:00:00', '2025-10-26 23:59:59', 7),
('Chop Suey', 3500, 45, '2025-01-08 10:00:00', '2025-10-26 23:59:59', 7),
('Pollo Agridulce', 4000, 40, '2025-01-08 10:00:00', '2025-10-26 23:59:59', 7),
('Wantanes x6', 2500, 60, '2025-01-08 10:00:00', '2025-10-26 23:59:59', 7),
('Coca Cola 1L', 600, 150, '2025-01-08 10:00:00', '2025-12-31 23:59:59', 7);

-- Café Targon 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Café Expreso', 800, 100, '2025-01-08 10:00:00', '2025-10-30 23:59:59', 8),
('Café con Leche', 1000, 90, '2025-01-08 10:00:00', '2025-10-30 23:59:59', 8),
('Cappuccino', 1200, 80, '2025-01-08 10:00:00', '2025-10-30 23:59:59', 8),
('Medialunas x3', 1500, 70, '2025-01-08 10:00:00', '2025-10-30 23:59:59', 8),
('Jugo Naranja', 900, 60, '2025-01-08 10:00:00', '2025-10-30 23:59:59', 8);

-- Pizzería Bandle 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Pizza Cuatro Quesos', 4500, 35, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 9),
('Pizza Jamón y Morrones', 4000, 40, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 9),
('Pizza Fugazzeta', 3800, 45, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 9),
('Fainá', 1000, 50, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 9),
('Pepsi 1.5L', 800, 100, '2025-01-09 10:00:00', '2025-12-31 23:59:59', 9);

-- Burger Zaun 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Hamburguesa Triple', 4500, 40, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 10),
('Hamburguesa Veggie', 3200, 45, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 10),
('Nuggets x10', 2500, 60, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 10),
('Aros de Cebolla', 1800, 50, '2025-01-09 10:00:00', '2025-10-30 23:59:59', 10),
('7up 1.5L', 800, 120, '2025-01-09 10:00:00', '2025-12-31 23:59:59', 10);

-- Sushi Bilgewater 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Sushi Roll California x10', 5200, 32, '2025-01-10 10:00:00', '2025-10-20 23:59:59', 11),
('Sushi Roll Philadelphia x10', 5800, 28, '2025-01-10 10:00:00', '2025-10-20 23:59:59', 11),
('Temaki Salmón', 3500, 40, '2025-01-10 10:00:00', '2025-10-20 23:59:59', 11),
('Gyoza x6', 2800, 50, '2025-01-10 10:00:00', '2025-10-20 23:59:59', 11),
('Cerveza Sapporo', 1500, 60, '2025-01-10 10:00:00', '2025-12-31 23:59:59', 11);

-- Tacos Ixtal 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Tacos al Pastor x3', 3200, 48, '2025-01-10 10:00:00', '2025-10-25 23:59:59', 12),
('Quesadillas x2', 2800, 52, '2025-01-10 10:00:00', '2025-10-25 23:59:59', 12),
('Enchiladas', 3500, 42, '2025-01-10 10:00:00', '2025-10-25 23:59:59', 12),
('Guacamole con Chips', 1800, 65, '2025-01-10 10:00:00', '2025-10-25 23:59:59', 12),
('Limonada 1L', 700, 150, '2025-01-10 10:00:00', '2025-12-31 23:59:59', 12);

-- Pastas Demacia 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Sorrentinos de Ricota', 4200, 38, '2025-01-11 10:00:00', '2025-10-28 23:59:59', 13),
('Canelones de Verdura', 4000, 40, '2025-01-11 10:00:00', '2025-10-28 23:59:59', 13),
('Fetuccini Alfredo', 4500, 35, '2025-01-11 10:00:00', '2025-10-28 23:59:59', 13),
('Pan de Ajo', 1200, 70, '2025-01-11 10:00:00', '2025-10-28 23:59:59', 13),
('Vino Tinto Copa', 1800, 50, '2025-01-11 10:00:00', '2025-12-31 23:59:59', 13);

-- Parrilla Noxus 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Vacío', 5200, 32, '2025-01-11 10:00:00', '2025-10-22 23:59:59', 14),
('Entraña', 5800, 28, '2025-01-11 10:00:00', '2025-10-22 23:59:59', 14),
('Morcilla', 1800, 55, '2025-01-11 10:00:00', '2025-10-22 23:59:59', 14),
('Provoleta', 2200, 45, '2025-01-11 10:00:00', '2025-10-22 23:59:59', 14),
('Stella Artois 1L', 1400, 70, '2025-01-11 10:00:00', '2025-12-31 23:59:59', 14);

-- Wok de Zaun 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Pollo Teriyaki', 3800, 42, '2025-01-12 10:00:00', '2025-10-26 23:59:59', 15),
('Cerdo Agridulce', 4200, 38, '2025-01-12 10:00:00', '2025-10-26 23:59:59', 15),
('Fideos con Verduras', 3200, 48, '2025-01-12 10:00:00', '2025-10-26 23:59:59', 15),
('Rollitos Primavera x4', 2300, 58, '2025-01-12 10:00:00', '2025-10-26 23:59:59', 15),
('Sprite 1L', 600, 140, '2025-01-12 10:00:00', '2025-12-31 23:59:59', 15);

-- Café Piltover 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Latte', 1300, 85, '2025-01-12 10:00:00', '2025-10-30 23:59:59', 16),
('Americano', 900, 95, '2025-01-12 10:00:00', '2025-10-30 23:59:59', 16),
('Té Chai', 1100, 75, '2025-01-12 10:00:00', '2025-10-30 23:59:59', 16),
('Tostado', 2000, 65, '2025-01-12 10:00:00', '2025-10-30 23:59:59', 16),
('Licuado Frutilla', 1200, 55, '2025-01-12 10:00:00', '2025-10-30 23:59:59', 16);

-- Pizzería Void 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Pizza Especial', 4800, 32, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 17),
('Pizza Roquefort', 4600, 35, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 17),
('Pizza Rúcula y Jamón', 4400, 38, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 17),
('Focaccia', 2500, 50, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 17),
('Manaos Cola 2L', 500, 180, '2025-01-13 10:00:00', '2025-12-31 23:59:59', 17);

-- Burger Freljord 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Hamburguesa BBQ', 4200, 42, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 18),
('Hamburguesa Bacon', 4500, 38, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 18),
('Milanesa Napolitana', 4800, 35, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 18),
('Papas Cheddar Bacon', 2500, 55, '2025-01-13 10:00:00', '2025-10-30 23:59:59', 18),
('Heineken 1L', 1600, 65, '2025-01-13 10:00:00', '2025-12-31 23:59:59', 18);

-- Sushi Targon 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Sushi Mix x20', 9500, 20, '2025-01-14 10:00:00', '2025-10-20 23:59:59', 19),
('Hot Roll x10', 6200, 25, '2025-01-14 10:00:00', '2025-10-20 23:59:59', 19),
('Edamame', 1800, 40, '2025-01-14 10:00:00', '2025-10-20 23:59:59', 19),
('Sopa Miso', 1500, 50, '2025-01-14 10:00:00', '2025-10-20 23:59:59', 19),
('Sake Caliente', 2500, 35, '2025-01-14 10:00:00', '2025-12-31 23:59:59', 19);

-- Parrilla Shurima 
INSERT INTO producto (nombre, precio, stock, fechaAlta, vencimiento, idLocal) VALUES
('Costillar', 6500, 25, '2025-01-14 10:00:00', '2025-10-22 23:59:59', 20),
('Ojo de Bife', 6800, 22, '2025-01-14 10:00:00', '2025-10-22 23:59:59', 20),
('Chorizo', 1500, 60, '2025-01-14 10:00:00', '2025-10-22 23:59:59', 20),
('Papas Fritas Rústicas', 1800, 55, '2025-01-14 10:00:00', '2025-10-22 23:59:59', 20),
('Corona 1L', 1700, 60, '2025-01-14 10:00:00', '2025-12-31 23:59:59', 20);

-- Promociones y su historial

INSERT INTO historialPromociones (idLocal, fechaAlta, fechaBaja) VALUES
(1, '2025-01-10 08:00:00', '2025-02-10 23:59:59'),
(2, '2025-01-15 08:00:00', NULL),
(3, '2025-01-20 08:00:00', NULL),
(4, '2025-02-01 08:00:00', '2025-03-01 23:59:59'),
(5, '2025-02-05 08:00:00', NULL),
(6, '2025-02-10 08:00:00', '2025-03-10 23:59:59'),
(7, '2025-02-15 08:00:00', NULL),
(8, '2025-02-20 08:00:00', NULL),
(9, '2025-03-01 08:00:00', '2025-04-01 23:59:59'),
(10, '2025-03-05 08:00:00', NULL),
(11, '2025-03-10 08:00:00', NULL),
(12, '2025-03-15 08:00:00', '2025-04-15 23:59:59'),
(13, '2025-03-20 08:00:00', NULL),
(14, '2025-03-25 08:00:00', NULL),
(15, '2025-04-01 08:00:00', '2025-05-01 23:59:59'),
(16, '2025-04-05 08:00:00', NULL),
(1, '2025-04-10 08:00:00', NULL),
(2, '2025-04-15 08:00:00', '2025-05-15 23:59:59'),
(3, '2025-04-20 08:00:00', NULL),
(4, '2025-05-01 08:00:00', NULL),
(5, '2025-05-05 08:00:00', '2025-06-05 23:59:59'),
(6, '2025-05-10 08:00:00', NULL),
(7, '2025-05-15 08:00:00', NULL),
(8, '2025-05-20 08:00:00', '2025-06-20 23:59:59'),
(9, '2025-06-01 08:00:00', NULL);

-- Promociones activas 
-- No pusimos todas las promociones como activas ya que los clientes no siempre usan promociones.
INSERT INTO promocion (idHistorialPromociones, nombrePromocion, descontar, estado, fechaAlta, fechaBaja) VALUES
(2, 'Combo Burger + Papas', 15.0, 1, '2025-01-15 08:00:00', NULL),
(3, 'Descuento Sushi Nights', 20.0, 1, '2025-01-20 08:00:00', NULL),
(5, 'Promo Pastas Familia', 30.0, 1, '2025-02-05 08:00:00', NULL),
(7, 'Wok Week', 18.0, 1, '2025-02-15 08:00:00', NULL),
(8, 'Café + Medialunas', 12.0, 1, '2025-02-20 08:00:00', NULL),
(10, 'Burger Flash', 20.0, 1, '2025-03-05 08:00:00', NULL),
(11, 'Sushi Premium', 15.0, 1, '2025-03-10 08:00:00', NULL),
(13, 'Pasta Night', 25.0, 1, '2025-03-20 08:00:00', NULL),
(14, 'Asado Total', 12.0, 1, '2025-03-25 08:00:00', NULL),
(16, 'Coffee Break', 10.0, 1, '2025-04-05 08:00:00', NULL),
(17, 'Pizza Martes', 35.0, 1, '2025-04-10 08:00:00', NULL),
(19, 'Sushi Friday', 22.0, 1, '2025-04-20 08:00:00', NULL);

-- Pagos

INSERT INTO pago (monto, idMetodoPago, fechaAlta) VALUES
(4300, 3, '2025-02-15 12:30:00'),
(5500, 1, '2025-02-18 13:15:00'),
(8200, 4, '2025-03-02 14:20:00'),
(3800, 2, '2025-03-05 19:45:00'),
(6700, 3, '2025-03-10 20:10:00'),
(4200, 1, '2025-03-15 12:00:00'),
(7800, 4, '2025-03-20 18:30:00'),
(5100, 2, '2025-03-25 21:15:00'),
(3600, 3, '2025-04-01 13:45:00'),
(9200, 1, '2025-04-05 19:20:00'),
(4900, 4, '2025-04-10 20:50:00'),
(6300, 2, '2025-04-15 12:40:00'),
(5700, 3, '2025-04-20 14:10:00'),
(8500, 1, '2025-04-25 19:00:00'),
(4500, 4, '2025-05-01 13:30:00'),
(7200, 2, '2025-05-05 20:20:00'),
(3900, 3, '2025-05-10 12:15:00'),
(6800, 1, '2025-05-15 18:45:00'),
(5400, 4, '2025-05-20 21:00:00'),
(4100, 2, '2025-05-25 13:20:00'),
(7600, 3, '2025-06-01 19:30:00'),
(5900, 1, '2025-06-05 20:40:00'),
(4400, 4, '2025-06-10 12:50:00'),
(8100, 2, '2025-06-15 14:30:00'),
(6200, 3, '2025-06-20 19:15:00'),
(4800, 1, '2025-06-25 21:25:00'),
(7300, 4, '2025-07-01 13:00:00'),
(5200, 2, '2025-07-05 20:10:00'),
(3700, 3, '2025-07-10 12:35:00'),
(6900, 1, '2025-07-15 18:20:00');

-- Pedidos 

INSERT INTO pedido (idPago, idEstadoPedido, idRepartidor, idPromocion, idUsuario, fechaAlta, totalFinal, descuentoAplicado) VALUES
(1, 4, 1, 1, 1, '2025-02-15 12:30:00', 4300, 645),
(2, 4, 1, NULL, 2, '2025-02-18 13:15:00', 5500, 0),
(3, 4, 1, 2, 3, '2025-03-02 14:20:00', 8200, 1640),
(4, 4, 1, NULL, 4, '2025-03-05 19:45:00', 3800, 0),
(5, 4, 1, 3, 5, '2025-03-10 20:10:00', 6700, 2010),
(6, 4, 1, NULL, 6, '2025-03-15 12:00:00', 4200, 0),
(7, 4, 1, 4, 7, '2025-03-20 18:30:00', 7800, 1404),
(8, 3, 3, NULL, 8, '2025-03-25 21:15:00', 5100, 0),
(9, 4, 3, 5, 9, '2025-04-01 13:45:00', 3600, 432),
(10, 4, 3, NULL, 10, '2025-04-05 19:20:00', 9200, 0),
(11, 4, 3, 6, 11, '2025-04-10 20:50:00', 4900, 980),
(12, 4, 5, NULL, 12, '2025-04-15 12:40:00', 6300, 0),
(13, 3, 5, 7, 13, '2025-04-20 14:10:00', 5700, 855),
(14, 4, 5, NULL, 14, '2025-04-25 19:00:00', 8500, 0),
(15, 4, 5, 8, 15, '2025-05-01 13:30:00', 4500, 1125),
(16, 4, 4, NULL, 16, '2025-05-05 20:20:00', 7200, 0),
(17, 2, 4, 9, 17, '2025-05-10 12:15:00', 3900, 585),
(18, 4, 10, NULL, 18, '2025-05-15 18:45:00', 6800, 0),
(19, 4, 10, 10, 19, '2025-05-20 21:00:00', 5400, 540),
(20, 4, 10, NULL, 20, '2025-05-25 13:20:00', 4100, 0),
(21, 4, 21, 11, 21, '2025-06-01 19:30:00', 7600, 2660),
(22, 3, 22, NULL, 22, '2025-06-05 20:40:00', 5900, 0),
(23, 4, 23, 12, 23, '2025-06-10 12:50:00', 4400, 880),
(24, 4, 24, NULL, 24, '2025-06-15 14:30:00', 8100, 0),
(25, 4, 25, 1, 25, '2025-06-20 19:15:00', 6200, 930),
(26, 4, 26, NULL, 26, '2025-06-25 21:25:00', 4800, 0),
(27, 2, 27, 2, 27, '2025-07-01 13:00:00', 7300, 1460),
(28, 4, 28, NULL, 28, '2025-07-05 20:10:00', 5200, 0),
(29, 4, 29, 3, 29, '2025-07-10 12:35:00', 3700, 1110),
(30, 4, 30, NULL, 30, '2025-07-15 18:20:00', 6900, 0);


-- Detalle pedido 

INSERT INTO detallePedido (idPedido, idProducto, cantidadProducto) VALUES
(1, 1, 4),
(1, 2, 3),
(2, 2, 3),
(2, 4, 1),
(3, 2, 6),
(3, 2, 1),
(4, 26, 1),
(4, 30, 1),
(5, 31, 1),
(5, 34, 1),
(5, 35, 1),
(6, 41, 1),
(6, 45, 1),
(7, 46, 1),
(7, 49, 1),
(7, 50, 1),
(8, 51, 1),
(8, 55, 2),
(9, 56, 2),
(9, 60, 1),
(10, 61, 1),
(10, 64, 1),
(10, 65, 1),
(11, 66, 1),
(11, 70, 1),
(12, 71, 1),
(12, 74, 1),
(12, 75, 1),
(13, 1, 1),
(13, 5, 1),
(14, 6, 2),
(14, 10, 1),
(15, 11, 1),
(15, 14, 1),
(16, 16, 1),
(16, 19, 1),
(16, 20, 1),
(17, 76, 2),
(17, 80, 1),
(18, 81, 1),
(18, 85, 1),
(19, 21, 1),
(19, 24, 1),
(20, 26, 1),
(20, 28, 1),
(20, 30, 1),
(21, 31, 2),
(21, 35, 2),
(22, 36, 1),
(22, 39, 1),
(22, 40, 1),
(23, 41, 1),
(23, 43, 1),
(24, 46, 2),
(24, 50, 2),
(25, 51, 1),
(25, 53, 1),
(25, 55, 1),
(26, 56, 1),
(26, 59, 1),
(27, 61, 1),
(27, 65, 2),
(28, 66, 1),
(28, 68, 1),
(28, 70, 1),
(29, 71, 1),
(29, 74, 1),
(30, 76, 2),
(30, 79, 1),
(30, 80, 1);

-- Reseñas

INSERT INTO resenia (idUsuario, idRepatidor, idLocal, calificacion, comentario, fechaAlta, estaActivo) VALUES

(1, 1, 1, 5.0, 'La mejor pizza que probé en mi vida', '2025-02-15 13:00:00', 1),
(2, 2, 3, 4.7, 'Sushi fresco, llegó perfecto', '2025-02-18 14:00:00', 1),
(3, 3, 1, 4.8, 'Pizza perfecta, masa crujiente', '2025-03-02 15:00:00', 1),
(4, 4, 4, 3.5, 'Tardó un poco pero rico', '2025-03-05 20:30:00', 1),
(5, 5, 5, 4.9, 'Pastas increíbles, recomiendo 100%', '2025-03-10 21:00:00', 1),
(6, 6, 6, 4.2, 'Buena parrilla, buen precio', '2025-03-15 13:00:00', 1),
(7, 7, 7, 4.7, 'Comida china auténtica', '2025-03-20 19:30:00', 1),
(8, 8, 8, 1.5, 'Café horrible, frío y quemado', '2025-03-25 22:00:00', 1),
(9, 9, 17, 1.0, 'La peor pizza, llegó congelada', '2025-04-01 14:30:00', 1),
(10, 10, 10, 1.8, 'Hamburguesa fría y mal cocida', '2025-04-05 20:00:00', 1),
(11, 11, 11, 4.4, 'Sushi fresco y sabroso', '2025-04-10 21:30:00', 1),
(12, 12, 12, 4.1, 'Buenos tacos', '2025-04-15 13:30:00', 1),
(13, 13, 13, 4.3, 'Pastas caseras ricas', '2025-04-20 15:00:00', 1),
(14, 14, 14, 4.8, 'Asado perfecto, carne de primera', '2025-04-25 20:00:00', 1),
(15, 15, 1, 4.9, 'Increíble calidad, super recomendado', '2025-05-01 14:30:00', 1),
(16, 16, 2, 4.5, 'Hamburguesa deliciosa', '2025-05-05 21:00:00', 1),
(17, 17, 8, 1.2, 'El peor café que probé, servicio lento', '2025-05-10 13:00:00', 1),
(18, 18, 6, 4.7, 'Carne de calidad', '2025-05-15 19:30:00', 1),
(19, 1, 3, 4.9, 'Sushi excelente, muy fresco', '2025-05-20 22:00:00', 1),
(20, 2, 4, 4.0, 'Tacos picantes, me gustó', '2025-05-25 14:00:00', 1),
(21, 3, 1, 5.0, 'La mejor experiencia de delivery', '2025-06-01 20:30:00', 1),
(22, 4, 5, 2.8, 'Las pastas llegaron pasadas', '2025-06-05 21:30:00', 1),
(23, 5, 3, 4.8, 'El mejor sushi de la zona', '2025-06-10 13:30:00', 1),
(24, 6, 7, 4.4, 'Comida oriental de calidad', '2025-06-15 15:30:00', 1),
(25, 7, 2, 4.2, 'Buenas hamburguesas', '2025-06-20 20:00:00', 1),
(26, 8, 17, 1.7, 'Pizza quemada y sin gusto', '2025-06-25 22:00:00', 1),
(27, 9, 11, 4.8, 'Sushi bilgewater es muy bueno', '2025-07-01 14:00:00', 1),
(28, 10, 12, 4.1, 'Buenos tacos', '2025-07-05 21:00:00', 1),
(29, 11, 5, 5.0, 'Excelentes pastas caseras', '2025-07-10 13:30:00', 1),
(30, 12, 14, 4.7, 'Asado exquisito, porción generosa', '2025-07-15 19:00:00', 1),
(31, 13, 7, 4.3, 'Buen wok', '2025-07-20 22:30:00', 1),
(32, 14, 8, 2.0, 'Café tibio, medialunas duras', '2025-07-25 14:30:00', 1),
(33, 15, 15, 1.3, 'Comida fría, verduras podridas', '2025-08-01 20:00:00', 1),
(34, 16, 19, 5.0, 'Sushi premium increíble, vale cada peso', '2025-08-05 21:30:00', 1),
(35, 17, 10, 1.5, 'Pésima calidad, nunca más pido', '2025-08-10 13:00:00', 1);

-- Creacion de Indices--

-- Indice 1: Para optimizar la búsqueda de pedidos por usuario.
-- Es una de las consultas más comunes que un usuario realizaría para ver su historial de pedidos.
-- Sin este índice, la base de datos tendría que escanear toda la tabla `pedido`.
CREATE INDEX indice_pedido_usr ON pedido(idUsuario);

-- Indice 2: Para optimizar la búsqueda de productos por local.
-- Cuando un usuario selecciona un local, el sistema debe mostrar rápidamente todos los productos disponibles.
-- Este índice acelera la recuperación de productos asociados a un `idLocal` específico.
CREATE INDEX indice_prod_local ON producto(idLocal);

-- Indice 3: Para optimizar la búsqueda de pedidos asignados a un repartidor.
-- Permite a los repartidores consultar rápidamente sus entregas asignadas,
CREATE INDEX idx_pedido_estado_repartidor ON pedido(idEstadoPedido, idRepartidor);

-- Indice 4: Para optimizar la búsqueda y ordenamiento de reseñas por local y calificación.
-- Permite buscar rápidamente todas las reseñas de un local y ordenarlas por calificación
-- sin un paso de ordenamiento adicional, optimizando una de las vistas más comunes para el usuario.
CREATE INDEX indice_resenia_local_calificacion ON resenia(idLocal, calificacion);

-- Indice 5: Para garantizar la unicidad y acelerar la búsqueda de usuarios por correo.
-- Es fundamental para la integridad de los datos (evita usuarios duplicados)
-- y para el rendimiento de operaciones clave como el login y el registro.
CREATE UNIQUE INDEX indice_usr_correo ON usuario(correo);

-- Indice 6: Para optimizar la búsqueda de locales por categoría.
CREATE INDEX index_local_categoria ON local(idCategoria);

-- Creacion de Consultas --

-- Consulta 1: Top 5 Repartidores con Más Entregas Realizadas
-- Permite al administrador de la plataforma identificar a los repartidores con mayor rendimiento.
-- Hace uso del indice_pedido_repartidor ON pedido(idEstadoPedido, idRepartidor);
SELECT
    r.nombre,
    r.apellido,
    COUNT(p.idPedido) AS total_entregas
FROM 
	repartidor AS r
JOIN pedido AS p 
	ON r.idRepartidor = p.idRepartidor
WHERE p.idEstadoPedido = 4 -- 4: Entregado
GROUP BY r.idRepartidor
ORDER BY total_entregas DESC
LIMIT 5;

-- Consulta 2: Locales con Calificación Promedio Inferior a 3.0
-- Permite detectar locales con bajo rendimiento y satisfacción del cliente
-- Hace uso del indice indice_resenia_local_calificacion y index_local_categoria
SELECT
    l.nombreLocal,
    c.nombreCategoria,
    AVG(re.calificacion) AS calificacion_promedio
FROM local AS l
JOIN resenia AS re 
	ON l.idLocal = re.idLocal
JOIN categoria AS c 
	ON l.idCategoria = c.idCategoria
GROUP BY l.idLocal
HAVING calificacion_promedio < 3.0
ORDER BY calificacion_promedio ASC;

-- Consulta 3: Productos Más Vendidos del Local "Pizzería Demacia"
-- Al saber cuáles son sus productos 'estrella', se puede gestionar mejor su stock
-- Hace uso del indice indice_prod_local
SELECT
    prod.nombre,
    SUM(dp.cantidadProducto) AS total_vendido
FROM 
	detallePedido AS dp
JOIN producto AS prod 
	ON dp.idProducto = prod.idProducto
WHERE prod.idLocal = (SELECT idLocal FROM local WHERE nombreLocal = 'Pizzería Demacia')
GROUP BY prod.idProducto
ORDER BY total_vendido DESC
LIMIT 5;

-- Consulta 4: Pedidos que Utilizaron una Promoción Específica 
-- Permite saber cuántos usuarios la utilizaron y cuál fue el volumen de ventas asociado a ella, justificando así la inversión en descuentos.
SELECT
    p.idPedido,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    pr.nombrePromocion,
    p.totalFinal,
    p.descuentoAplicado,
    p.fechaAlta AS fecha_pedido
FROM 
	pedido AS p
JOIN promocion AS pr 
	ON p.idPromocion = pr.idPromocion
JOIN usuario AS u 
	ON p.idUsuario = u.idUsuario
WHERE pr.nombrePromocion = 'Combo Burger + Papas';

-- Consulta 5: Productos de un local que nunca han sido vendidos
-- hace uso del indice indice_prod_local tanto en la clausula where como en el JOIN
SELECT
    p.nombre AS producto_no_vendido,
    p.precio,
    p.stock
FROM producto AS p
LEFT JOIN detallePedido AS dp 
	ON p.idProducto = dp.idProducto
WHERE p.idLocal = 6
  AND dp.idDetallePedido IS NULL;
  
-- Consulta 6: Ver el detalle completo de un pedido específico
-- Cuando un usuario llama con una duda o un reclamo sobre un pedido, esta consulta permite al personal de soporte ver instantáneamente todos los detalles
-- Cambiar el '1' por el ID del pedido que se quiera consultar
SELECT
    p.idPedido,
    p.fechaAlta,
    u.nombre AS cliente_nombre,
    u.apellido AS cliente_apellido,
    u.direccion AS direccion_entrega,
    prod.nombre AS producto,
    dp.cantidadProducto,
    prod.precio AS precio_unitario,
    (dp.cantidadProducto * prod.precio) AS subtotal_producto
FROM 
	pedido AS p
JOIN usuario AS u 
	ON p.idUsuario = u.idUsuario
JOIN detallePedido AS dp 
	ON p.idPedido = dp.idPedido
JOIN producto AS prod 
	ON dp.idProducto = prod.idProducto
WHERE p.idPedido = 1; 

-- Consulta 7: Usuarios que han gastado más que el promedio general de gasto por usuario
-- CTE
-- Se define una tabla temporal llamada 'gastos_por_usuario' que existe solo para esta consulta.calcula cuánto gastó cada usuario sumando todos sus pedidos que no fueron cancelados
WITH gastos_por_usuario AS (
    SELECT
        idUsuario,
        SUM(totalFinal) AS gasto_total
    FROM pedido
    WHERE idEstadoPedido != 5 -- Excluimos pedidos cancelados
    GROUP BY idUsuario
)
SELECT
    u.nombre,
    u.apellido,
    gpu.gasto_total
FROM usuario AS u
JOIN gastos_por_usuario AS gpu 
	ON u.idUsuario = gpu.idUsuario
WHERE gpu.gasto_total > (SELECT AVG(gasto_total) FROM gastos_por_usuario);


-- Consulta 8: Locales con mayor cantidad de reseñas en el último anio
-- Muestra los locales que están generando mayor interacción con los usuarios
-- Hace uso del indice indice_resenia_local_calificacion
SELECT
    l.nombreLocal,
    COUNT(r.idResenia) AS cantidad_resenias
FROM local AS l
LEFT JOIN resenia AS r ON l.idLocal = r.idLocal
WHERE r.fechaAlta >= 
	DATE_SUB(CURDATE(), INTERVAL 1 year)
GROUP BY l.idLocal
ORDER BY cantidad_resenias DESC
LIMIT 3;


-- Consulta 9: verifica si hay productos con stock menor a 30 
-- Permite saber qué productos necesitan reponer urgentemente para evitar perder ventas
SELECT
    p.nombre,
    p.stock,
    l.nombreLocal AS local
FROM 
	producto AS p
JOIN local AS l 
	ON p.idLocal = l.idLocal
WHERE p.stock < 30
ORDER BY p.stock ASC;

-- Consulta 10: Historial de Pedidos de un Usuario.
-- Es la consulta principal para la sección 'Mis Pedidos' dentro del perfil del usuario en la aplicación.
-- Hace uso del indice indice_pedido_usr a traves del JOIN 
SELECT
    p.idPedido,
    p.fechaAlta,
    l.nombreLocal,
    p.totalFinal,
    ep.descripcion AS estado
FROM pedido AS p
JOIN usuario AS u 
	ON p.idUsuario = u.idUsuario
JOIN detallePedido AS dp 
	ON p.idPedido = dp.idPedido
JOIN producto AS pr 
	ON dp.idProducto = pr.idProducto
JOIN local AS l 
	ON pr.idLocal = l.idLocal
JOIN estadoPedido AS ep 
	ON p.idEstadoPedido = ep.idEstadoPedido
WHERE u.correo = 'fiora@demacia.com'  
GROUP BY p.idPedido, p.fechaAlta, l.nombreLocal, p.totalFinal, ep.descripcion
ORDER BY p.fechaAlta DESC;

-- Consulta 11: Ver el historial de promociones de un local específico 
SELECT 
    l.nombreLocal,
    p.nombrePromocion,
    p.descontar,
    p.estado,
    hp.fechaAlta AS fecha_inicio,
    hp.fechaBaja AS fecha_fin
FROM local AS l
JOIN historialPromociones AS hp 
	ON l.idLocal = hp.idLocal
JOIN promocion AS p 
	ON hp.idHistorialPromociones = p.idHistorialPromociones
WHERE l.nombreLocal = 'Pizzería Demacia' 
ORDER BY hp.fechaAlta DESC;

-- creacion de vistas --

-- basado en la consulta 11
-- Vista para el historial de promociones por local

CREATE VIEW V_HistorialPromociones AS
SELECT 
    l.idLocal,
    l.nombreLocal,
    p.nombrePromocion,
    p.descontar,
    p.estado,
    hp.fechaAlta AS fecha_inicio,
    hp.fechaBaja AS fecha_fin
FROM 
	local AS l
JOIN historialPromociones AS hp 
	ON l.idLocal = hp.idLocal
JOIN promocion AS p 
	ON hp.idHistorialPromociones = p.idHistorialPromociones;

SELECT * FROM V_HistorialPromociones 
	WHERE nombreLocal = 'Pizzería Demacia' ORDER BY fecha_inicio DESC;