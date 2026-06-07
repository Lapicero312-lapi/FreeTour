/* ============================
   TABLAS PRINCIPALES
   ============================ */

-- Ciudades
INSERT INTO Ciudades (nombre) VALUES
('Santa Marta'),('Bogotá'),('Medellín'),('Cartagena'),('Barranquilla');

-- TiposPersonas
INSERT INTO TiposPersonas (nombre) VALUES
('Turista'),('Guia');


-- Personas
INSERT INTO Personas (nombre,direccion,telefono,documento_identidad,fecha_nacimiento,email,id_tipo_persona)
VALUES
('Carlos Pérez','Calle 10','3001234567','CC123456','1990-05-10','carlos@mail.com',1),
('Ana Gómez','Carrera 20','3017654321','CC654321','1985-03-15','ana@mail.com',2),
('Luis Torres','Av. Libertador','3029876543','PAS987654','1992-07-22','luis@mail.com',1),
('María López','Calle 45','3034567890','CC111222','1995-11-30','maria@mail.com',1),
('Pedro Díaz','Carrera 7','3041122334','PAS333444','1988-01-05','pedro@mail.com',2);

-- 15 guías adicionales
INSERT INTO Personas (nombre,direccion,telefono,documento_identidad,fecha_nacimiento,email,id_tipo_persona) VALUES
('Jorge Ramírez','Calle 12 #8-20','3001112233','CC100001','1980-02-15','jorge.ramirez@mail.com',2),
('Sofía Martínez','Carrera 5 #10-30','3002223344','CC100002','1987-06-20','sofia.martinez@mail.com',2),
('Andrés López','Av. Central #45','3003334455','PAS100003','1992-09-10','andres.lopez@mail.com',2),
('Valentina Torres','Calle 18 #22-40','3004445566','CC100004','1990-04-25','valentina.torres@mail.com',2),
('Ricardo Gómez','Carrera 7 #15-60','3005556677','CC100005','1985-11-05','ricardo.gomez@mail.com',2),
('Camila Herrera','Av. Libertador #100','3006667788','PAS100006','1993-01-30','camila.herrera@mail.com',2),
('Felipe Morales','Calle 20 #30-12','3007778899','CC100007','1988-07-12','felipe.morales@mail.com',2),
('Laura Castro','Carrera 8 #25-50','3008889900','CC100008','1991-03-18','laura.castro@mail.com',2),
('Daniel Sánchez','Av. Principal #12','3009990011','PAS100009','1986-12-22','daniel.sanchez@mail.com',2),
('Paula Díaz','Calle 33 #45-60','3011112233','CC100010','1994-05-14','paula.diaz@mail.com',2),
('Mateo Rodríguez','Carrera 10 #5-20','3012223344','CC100011','1989-08-09','mateo.rodriguez@mail.com',2),
('Isabella Ramírez','Av. Bolívar #200','3013334455','PAS100012','1990-10-01','isabella.ramirez@mail.com',2),
('Sebastián Pérez','Calle 40 #12-30','3014445566','CC100013','1987-01-25','sebastian.perez@mail.com',2),
('Gabriela López','Carrera 12 #18-40','3015556677','CC100014','1992-06-11','gabriela.lopez@mail.com',2),
('Tomás Torres','Av. Santander #50','3016667788','PAS100015','1984-09-03','tomas.torres@mail.com',2);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Carlos Pérez', 'Calle 10 #5-20', '3001234567', 'CEDULA123456', '1985-04-12', 'carlos.perez@correo.com', 2);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Samuel Pinto', 'Calle 20 #30-12', '3001234672', 'CEDULA123666', '1985-04-11', 'samuel.pinto@correo.com', 2);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('María Gómez', 'Carrera 15 #8-30', '3012345678', 'CEDULA234567', '1990-07-25', 'maria.gomez@correo.com', 2);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Juan Rodríguez', 'Av. Libertador #20-15', '3023456789', 'CEDULA345678', '1982-11-03', 'juan.rodriguez@correo.com', 2);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Ana Martínez', 'Calle 22 #12-40', '3034567890', 'CEDULA456789', '1995-02-18', 'ana.martinez@correo.com', 2);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Luis Herrera', 'Carrera 7 #45-60', '3045678901', 'CEDULA567890', '1988-09-09', 'luis.herrera@correo.com', 2);


INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Juan Herrera','Calle 12 #5','3051112233','CC777888','1991-02-14','juan.herrera@mail.com',1);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Andrés Ramírez','Av. Central #45','3053334455','CC555666','1989-09-10','andres.ramirez@mail.com',1);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Felipe Castro','Carrera 15 #10','3055556677','CC333444','1990-04-05','felipe.castro@mail.com',1);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Laura Sánchez','Calle 22 #18','3056667788','PAS444555','1992-08-20','laura.sanchez@mail.com',1);

INSERT INTO Personas (nombre, direccion, telefono, documento_identidad, fecha_nacimiento, email, id_tipo_persona)
VALUES ('Diego Morales','Av. Libertador #100','3057778899','CC999000','1995-01-30','diego.morales@mail.com',1);

UPDATE Personas
SET apellido = LTRIM(RTRIM(RIGHT(nombre, LEN(nombre) - CHARINDEX(' ', nombre)))),
    nombre   = LTRIM(RTRIM(LEFT(nombre, CHARINDEX(' ', nombre) - 1)))
WHERE CHARINDEX(' ', nombre) > 0;



-- EstadosCategorias
INSERT INTO EstadosCategorias (nombre_estado,descripcion) VALUES
('ACTIVO','Disponible'),('INACTIVO','No disponible');


-- CategoriasTours
INSERT INTO CategoriasTours (fecha_estado_actual,nombre,descripcion,icono,id_estado_categoria)
VALUES
(GETDATE(),'Cultural','Visitas a museos','icon1.png',1),
(GETDATE(),'Aventura','Deportes extremos','icon2.jpg',1),
(GETDATE(),'Playa','Tours de playa','icon3.png',1),
(GETDATE(),'Montaña','Excursiones','icon4.jpg',2),
(GETDATE(),'Gastronomía','Comida típica','icon5.png',1);

-- Guias
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil)
VALUES (1,11,'Guía de ciudad','guia1.png');

INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil)
VALUES (2,10,'Guía de montaña','guia2.jpg');

INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil)
VALUES (5,14,'Guía de playa','guia5.png');

INSERT INTO Guias (id_guia, id_persona, descripcion_guia, foto_perfil)
VALUES (3, 38, 'Guía especializado en historia colonial y cocina tradicional', 'guia18.jpg');

INSERT INTO Guias (id_guia, id_persona, descripcion_guia, foto_perfil)
VALUES (6, 34, 'Experto en ecoturismo y senderismo por parques naturales', 'guia28.png');

INSERT INTO Guias (id_guia, id_persona, descripcion_guia, foto_perfil)
VALUES (7, 35, 'Guía bilingüe con experiencia en recorridos urbanos y gastronómicos', 'guia39.jpg');

INSERT INTO Guias (id_guia, id_persona, descripcion_guia, foto_perfil)
VALUES (8, 36, 'Especialista en turismo arqueológico y sitios históricos', 'guia41.png');

INSERT INTO Guias (id_guia, id_persona, descripcion_guia, foto_perfil)
VALUES (4, 37, 'Guía certificado en turismo de aventura y deportes extremos', 'guia55.jpg');

INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (8,22,'Guía histórico','guia22.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (9,23,'Guía de naturaleza','guia23.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (10,24,'Guía de montaña','guia24.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (11,25,'Guía de ciudad','guia25.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (12,26,'Guía de playa','guia26.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (13,27,'Guía gastronómico','guia27.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (14,28,'Guía de aventura','guia28.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (15,29,'Guía cultural','guia29.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (16,30,'Guía histórico','guia30.png');
INSERT INTO Guias (id_guia,id_persona,descripcion_guia,foto_perfil) VALUES (17,31,'Guía de naturaleza','guia31.png');

-- Estados_tours
INSERT INTO Estados_tours (nombre_estado,descripcion) VALUES ('ACTIVO','Disponible');
INSERT INTO Estados_tours (nombre_estado,descripcion) VALUES ('INACTIVO','Suspendido');

-- Tours
INSERT INTO Tours (nombre_comercial,descripcion,fecha_estado_actual,id_categoria_tour,id_estado,id_guia,capacidad_maxima)
VALUES ('Tour Playa Blanca','Visita a Playa Blanca',GETDATE(),1,1,1,30);

INSERT INTO Tours (nombre_comercial,descripcion,fecha_estado_actual,id_categoria_tour,id_estado,id_guia,capacidad_maxima)
VALUES ('Tour Centro Histórico','Recorrido cultural',GETDATE(),1,1,2,25);

INSERT INTO Tours (nombre_comercial,descripcion,fecha_estado_actual,id_categoria_tour,id_estado,id_guia,capacidad_maxima)
VALUES ('Tour Montaña Nevada','Excursión a la Sierra',GETDATE(),4,1,2,20);

INSERT INTO Tours (nombre_comercial,descripcion,fecha_estado_actual,id_categoria_tour,id_estado,id_guia,capacidad_maxima)
VALUES ('Tour Gastronómico','Comida típica',GETDATE(),5,1,1,15);

INSERT INTO Tours (nombre_comercial,descripcion,fecha_estado_actual,id_categoria_tour,id_estado,id_guia,capacidad_maxima)
VALUES ('Tour Aventura','Deportes extremos',GETDATE(),2,1,2,10);

select * from tours


-- Turistas
INSERT INTO Turistas (id_ciudad_nacimiento,id_persona,codigo_turista) VALUES (3,1,1001);
INSERT INTO Turistas (id_ciudad_nacimiento,id_persona,codigo_turista) VALUES (2,3,1002);
INSERT INTO Turistas (id_ciudad_nacimiento,id_persona,codigo_turista) VALUES (3,4,1003);
INSERT INTO Turistas (id_ciudad_nacimiento,id_persona,codigo_turista) VALUES (4,14,1004);
INSERT INTO Turistas (id_ciudad_nacimiento,id_persona,codigo_turista) VALUES (5,13,1006);
INSERT INTO Turistas (id_ciudad_nacimiento,id_persona,codigo_turista) VALUES (5,15,1007);



-- Transportadoras
INSERT INTO Transportadoras (nombre,telefono,nit) VALUES ('TransCaribe','1234567','900111222');
INSERT INTO Transportadoras (nombre,telefono,nit) VALUES ('TransAndes','7654321','900333444');
INSERT INTO Transportadoras (nombre,telefono,nit) VALUES ('TransNorte','9876543','900555666');
INSERT INTO Transportadoras (nombre,telefono,nit) VALUES ('TransSur','4567890','900777888');
INSERT INTO Transportadoras (nombre,telefono,nit) VALUES ('TransExpress','1122334','900999000');

--tipo tranporte
INSERT INTO TiposTransportes (nombre) VALUES ('TERRESTRE');
INSERT INTO TiposTransportes (nombre) VALUES ('MARITIMO');
INSERT INTO TiposTransportes (nombre) VALUES ('AEREO');



-- Transportes
INSERT INTO Transportes (id_transportadora,descripcion,id_tipo_transporte) VALUES (1,'Bus turístico',1);
INSERT INTO Transportes (id_transportadora,descripcion,id_tipo_transporte) VALUES (2,'Lancha rápida',2);
INSERT INTO Transportes (id_transportadora,descripcion,id_tipo_transporte) VALUES (3,'Avión charter',3);
INSERT INTO Transportes (id_transportadora,descripcion,id_tipo_transporte) VALUES (4,'Camioneta 4x4',1);
INSERT INTO Transportes (id_transportadora,descripcion,id_tipo_transporte) VALUES (5,'Buseta urbana',1);
INSERT INTO Transportes (id_transportadora, descripcion, id_tipo_transporte)
VALUES (1, 'Helicóptero turístico para recorridos aéreos panorámicos', 3);
INSERT INTO Transportes (id_transportadora, descripcion, id_tipo_transporte)
VALUES (2, 'Yate privado para excursiones marítimas de lujo', 2); 
INSERT INTO Transportes (id_transportadora, descripcion, id_tipo_transporte)
VALUES (3, 'Camión de carga para logística terrestre de equipos turísticos', 1);
INSERT INTO Transportes (id_transportadora, descripcion, id_tipo_transporte)
VALUES (4, 'Bote fluvial para recorridos por ríos y caños', 2); 
INSERT INTO Transportes (id_transportadora, descripcion, id_tipo_transporte)
VALUES (5, 'Vehículo adaptado para personas con movilidad reducida', 1); 

-- EstadosPagos
INSERT INTO EstadosPagos (nombre_estado,descripcion) VALUES ('PAGO','Pago completo');
INSERT INTO EstadosPagos (nombre_estado,descripcion) VALUES ('ABONO','Pago parcial');
INSERT INTO EstadosPagos (nombre_estado,descripcion) VALUES ('PENDIENTE','Pendiente de pago');


-- PagosReservas
INSERT INTO PagosReservas (fecha_estado_actual,fecha_pago,metodo_pago,monto_total,id_estado_pago)
VALUES (GETDATE(),'2025-11-01','EFECTIVO',50000,1);
INSERT INTO PagosReservas (fecha_estado_actual,fecha_pago,metodo_pago,monto_total,id_estado_pago)
VALUES (GETDATE(),'2025-11-02','TARJETA',25000,2);
INSERT INTO PagosReservas (fecha_estado_actual,fecha_pago,metodo_pago,monto_total,id_estado_pago)
VALUES (GETDATE(),'2025-11-03','TRANSFERENCIA',100000,1);
INSERT INTO PagosReservas (fecha_estado_actual,fecha_pago,metodo_pago,monto_total,id_estado_pago)
VALUES (GETDATE(),'2025-11-04','EFECTIVO',75000,2);
INSERT INTO PagosReservas (fecha_estado_actual,fecha_pago,metodo_pago,monto_total,id_estado_pago)
VALUES (GETDATE(),'2025-11-05','TARJETA',30000,3);

-- EstadosReservas
INSERT INTO EstadosReservas (id_estado_reserva,nombre_estado,descripcion) VALUES (1,'CONFIRMADA','Se hizo la petición');
INSERT INTO EstadosReservas (id_estado_reserva,nombre_estado,descripcion) VALUES (2,'CANCELADA','Reserva cancelada');
INSERT INTO EstadosReservas (id_estado_reserva,nombre_estado,descripcion) VALUES (4,'PENDIENTE','Pendiente de confirmación');
INSERT INTO EstadosReservas (id_estado_reserva,nombre_estado,descripcion) VALUES (5,'COMPLETADA','Reserva completada');

INSERT INTO EstadosGrupos (nombre_estado, descripcion)
VALUES ('ABIERTO','Grupo disponible');

INSERT INTO EstadosGrupos (nombre_estado, descripcion)
VALUES ('CERRADO','Grupo finalizado');


-- Grupos
INSERT INTO Grupos (id_guia,nombre,hora_salida,capacidad_maxima,id_estado_grupo,fecha_estado_actual)
VALUES (8,'Grupo Playa','08:00:00',30,1,GETDATE());
INSERT INTO Grupos (id_guia,nombre,hora_salida,capacidad_maxima,id_estado_grupo,fecha_estado_actual)
VALUES (9,'Grupo Centro','09:00:00',25,1,GETDATE());
INSERT INTO Grupos (id_guia,nombre,hora_salida,capacidad_maxima,id_estado_grupo,fecha_estado_actual)
VALUES (10,'Grupo Montaña','07:00:00',20,1,GETDATE());
INSERT INTO Grupos (id_guia,nombre,hora_salida,capacidad_maxima,id_estado_grupo,fecha_estado_actual)
VALUES (11,'Grupo Gastronómico','12:00:00',15,1,GETDATE());
INSERT INTO Grupos (id_guia,nombre,hora_salida,capacidad_maxima,id_estado_grupo,fecha_estado_actual)
VALUES (12,'Grupo Aventura','06:00:00',10,1,GETDATE());

select * from guias

-- Reservas
INSERT INTO Reservas (fecha_estado_actual,id_estado_reserva,numero_personas,id_tour,id_persona,id_grupo,monto_total)
VALUES (GETDATE(),1,2,6,1,2,100000);
INSERT INTO Reservas (fecha_estado_actual,id_estado_reserva,numero_personas,id_tour,id_persona,id_grupo,monto_total)
VALUES (GETDATE(),1,3,17,3,5,75000);
INSERT INTO Reservas (fecha_estado_actual,id_estado_reserva,numero_personas,id_tour,id_persona,id_grupo,monto_total)
VALUES (GETDATE(),1,4,9,4,4,120000);



select*from reservas
-- Pagos_Reserva_Reservas
INSERT INTO Pagos_Reserva_Reservas (id_pago,id_reserva,monto_consignado) VALUES (1,5,50000);
INSERT INTO Pagos_Reserva_Reservas (id_pago,id_reserva,monto_consignado) VALUES (2,7,25000);
INSERT INTO Pagos_Reserva_Reservas (id_pago,id_reserva,monto_consignado) VALUES (3,17,58000);

INSERT INTO Precios (precio, moneda) VALUES (50000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (75000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (100000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (120000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (150000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (200000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (250000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (300000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (350000, 'COP');
INSERT INTO Precios (precio, moneda) VALUES (400000, 'COP');

INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Parque Central Santa Marta', 11.240000, -74.200000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Terminal de Transportes Bogotá', 4.628000, -74.170000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Aeropuerto Rafael Núñez Cartagena', 10.442000, -75.513000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Plaza Mayor Medellín', 6.244000, -75.581000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Museo del Oro Bogotá', 4.601000, -74.072000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Malecón Barranquilla', 10.968000, -74.781000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Centro Histórico Santa Marta', 11.241000, -74.213000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Estación Norte Cali', 3.451000, -76.532000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Parque Tayrona Entrada Principal', 11.300000, -74.050000);
INSERT INTO PuntosEncuentros (direccion, lat, lon) VALUES ('Plaza Bolívar Bogotá', 4.598000, -74.077000);


INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (2, 11, '2025-11-02', 'El guía fue muy atento', 4);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (1, 12, '2025-11-03', 'Hermosos paisajes, transporte cómodo', 5);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (18, 13, '2025-11-04', 'La comida podría mejorar', 3);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (6, 14, '2025-11-05', 'Muy divertido y bien organizado', 5);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (16, 15, '2025-11-06', 'El transporte fue puntual', 4);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (15, 16, '2025-11-07', 'El tour estuvo demasiado largo', 2);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (7, 17, '2025-11-08', 'Muy buena experiencia en familia', 5);
INSERT INTO Resenas (id_tour, id_persona, fecha, texto, calificacion)
VALUES (9, 18, '2025-11-09', 'El guía no explicó suficiente', 3);



INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (1, 'resena1.png', '2025-11-01', '.png', 2048);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (2, 'resena2.jpg', '2025-11-02', '.jpg', 3072);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (3, 'resena3.png', '2025-11-03', '.png', 1024);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (4, 'resena4.jpg', '2025-11-04', '.jpg', 4096);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (5, 'resena5.png', '2025-11-05', '.png', 512);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (6, 'resena6.jpg', '2025-11-06', '.jpg', 8192);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (7, 'resena7.png', '2025-11-07', '.png', 256);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (8, 'resena8.jpg', '2025-11-08', '.jpg', 16384);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (9, 'resena9.png', '2025-11-09', '.png', 10240);

INSERT INTO Multimedias_resenas (id_multimedia, archivo, fecha_subida, formato, tamanio_archivo)
VALUES (10, 'resena10.jpg', '2025-11-10', '.jpg', 20480);


INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (2048, 'Imagen promocional del tour Tayrona');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (4096, 'Video introductorio del guía');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (1024, 'Mapa del recorrido en Santa Marta');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (8192, 'Galería de fotos del tour Cartagena');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (512, 'Icono de punto de encuentro');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (16384, 'Video completo del tour Medellín');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (256, 'Miniatura para reseñas');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (20480, 'Archivo multimedia de promoción Bogotá');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (10240, 'Galería de fotos de Barranquilla');
INSERT INTO Multimedias (limite_tamanio, descripcion) VALUES (3072, 'Imagen de portada para el sitio web');


INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (1, 'Agregar más horarios de salida', '2025-11-01');

INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (2, 'Ofrecer descuentos para grupos grandes', '2025-11-02');

INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (6, 'Mejorar la señalización en los puntos de encuentro', '2025-11-03');

INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (7, 'Incluir más opciones vegetarianas en la comida', '2025-11-04');

INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (9, 'Ofrecer transporte privado para familias', '2025-11-05');

INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (15, 'Dar más tiempo en cada parada del recorrido', '2025-11-06');

INSERT INTO Sugerencias (id_tour, descripcion, fecha)
VALUES (16, 'Incluir guías bilingües en inglés y francés', '2025-11-07');

select * from tours

INSERT INTO AprobacionesInternas (nombre_estado) VALUES ('EN PROCESO DE VERIFICACION');
INSERT INTO AprobacionesInternas (nombre_estado) VALUES ('VERIFICADO');
INSERT INTO AprobacionesInternas (nombre_estado) VALUES ('NO VERIFICADO');

--Idiomas
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Español', 'ES');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Inglés', 'EN');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Francés', 'FR');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Alemán', 'DE');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Italiano', 'IT');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Portugués', 'PT');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Chino', 'ZH');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Japonés', 'JA');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Ruso', 'RU');
INSERT INTO Idiomas (nombre, codigo_idioma) VALUES ('Árabe', 'AR');

--idiomatour
-- Tour 7 en Español
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (1, 1);
-- Tour 8 en Inglés
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (2, 2);
-- Tour 9 en Francés
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (6, 3);
-- Tour 10 en Alemán
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (7, 4);
-- Tour 11 en Italiano
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (18, 5);
-- Tour 12 en Portugués
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (19, 6);
-- Tour 13 en Chino
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (14, 7);
-- Tour 14 en Japonés
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (15, 8);
-- Tour 15 en Ruso
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (16, 9);
-- Tour 16 en Árabe
INSERT INTO Tours_Idiomas (id_tour, id_idioma) VALUES (17, 10);


--ToursCiudades
-- Tour 7 en Ciudad 1
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (1, 1);
-- Tour 8 en Ciudad 2
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (2, 2);
-- Tour 9 en Ciudad 3
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (6, 3);
-- Tour 10 en Ciudad 4
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (7, 5);
-- Tour 11 en Ciudad 1
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (9, 2);
-- Tour 12 en Ciudad 2
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (15, 3);
-- Tour 13 en Ciudad 3
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (16, 4);
-- Tour 14 en Ciudad 4
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (17, 5);
-- Tour 15 en Ciudad 5
INSERT INTO ToursCiudades (id_tour, id_ciudad) VALUES (18, 1);


--Logistica
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (7, 'Recorrido por el centro histórico y visita al museo principal', '02:30:00', 1);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (1, 'Tour guiado por la playa y caminata ecológica en senderos naturales', '03:00:00', 2);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (9, 'Visita a monumentos emblemáticos y degustación gastronómica local', '04:00:00', 3);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (2, 'Recorrido panorámico en transporte turístico y parada en miradores', '02:00:00', 4);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (6, 'Caminata guiada por parques naturales y explicación de flora y fauna', '03:30:00', 5);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (15, 'Visita a sitios religiosos y explicación histórica de la arquitectura', '02:45:00', 6);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (16, 'Tour nocturno por la ciudad con actividades culturales y música en vivo', '03:15:00', 7);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (17, 'Excursión a reservas naturales con transporte y guía especializado', '05:00:00', 8);
INSERT INTO Logisticas (id_tour, itinerario, duracion_estimado, id_punto_encuentro)
VALUES (18, 'Recorrido gastronómico por mercados locales y talleres de cocina', '02:20:00', 9);

--logisticaTransportes
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (1, 6, '2025-11-20');
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (2, 7, '2025-11-21');
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (3, 8, '2025-11-22');
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (4, 9, '2025-11-23');
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (5, 10, '2025-11-24');
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (6, 6, NULL); -- aún activo
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (7, 7, NULL); -- aún activo
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (8, 8, '2025-11-25');
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (9, 9, NULL); -- aún activo
INSERT INTO LogisticaTransporte (id_logistica, id_transporte, fecha_finalizacion)
VALUES (10, 10, '2025-11-26');

--DISPONIBILIDADES
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-17', '08:00:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-18', '09:30:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-19', '14:00:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-20', '10:15:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-21', '16:45:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-22', '07:00:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-23', '11:30:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-24', '13:00:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-25', '15:20:00');
INSERT INTO Disponibilidades (fecha_disponibilidad, hora_disponibilidad)
VALUES ('2025-11-26', '17:00:00');

--DISPONIBILIDADES TOURS
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (1, 1, '2025-11-17', '2025-11-20');
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (2, 2, '2025-11-18', '2025-11-22');
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (6, 3, '2025-11-19', NULL); -- disponibilidad abierta
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (7, 4, '2025-11-20', '2025-11-25');
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (9, 5, '2025-11-21', '2025-11-28');
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (18, 6, '2025-11-22', NULL); -- aún vigente
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (17, 7, '2025-11-23', '2025-11-30');
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (16, 8, '2025-11-24', '2025-12-02');
INSERT INTO DisponibilidadesTours (id_tour, id_disponibilidad, fecha_inicio_disponibilidad, fecha_fin_disponibilidad)
VALUES (15, 9, '2025-11-25', NULL); -- sin fecha fin


--TOURSMULTIMEDIA
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (1, 'tour7_presentacion.mp4');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (2, 'tour8_intro.mp4');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (3, 'tour9_fotos.jpeg');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (4, 'tour10_video.mp4');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (5, 'tour11_imagen.jpeg');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (6, 'tour12_clip.mp4');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (7, 'tour13_foto.jpeg');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (8, 'tour14_video.mp4');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (9, 'tour15_imagen.jpeg');
INSERT INTO Tours_Multimedias (id_multimedia, archivo_video)
VALUES (10, 'tour16_presentacion.mp4');

--MULTIMEDIA TOUR TOURS
INSERT INTO Multimedias_tour_Tours (id_tour_multimedia, id_tour)
VALUES (1, 7);
INSERT INTO Multimedias_tour_Tours (id_tour_multimedia, id_tour)
VALUES (2, 9);
INSERT INTO Multimedias_tour_Tours (id_tour_multimedia, id_tour)
VALUES (3, 15);
INSERT INTO Multimedias_tour_Tours (id_tour_multimedia, id_tour)
VALUES (4, 16);
INSERT INTO Multimedias_tour_Tours (id_tour_multimedia, id_tour)
VALUES (5, 17);
INSERT INTO Multimedias_tour_Tours (id_tour_multimedia, id_tour)
VALUES (6, 18);


--MULTIMEDIAS RESENA RESENAS
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (1, 7);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (2, 8);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (3, 9);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (4, 10);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (5, 11);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (6, 12);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (7, 13);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (8, 14);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (9, 15);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (10, 16);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (11, 17);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (12, 18);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (13, 19);
INSERT INTO Multimedias_resena_Resenas (id_resena_multimedia, id_resena)
VALUES (14, 20);


--TRANSPORTES AEREOS
INSERT INTO TransportesAereos (id_transporte, matricula_aerea)
VALUES (3, 'HK1234');
INSERT INTO TransportesAereos (id_transporte, matricula_aerea)
VALUES (6, 'HELI321'); -- Helicóptero turístico

select*from transportes
select*from tiposTransportes

--TRANSPORTES TERRESTRES
INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
VALUES (1, 'BUS123'); 
INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
VALUES (4, 'CAM456');
INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
VALUES (5, 'BUS789'); 
INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
VALUES (10, 'TRK321');
INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
VALUES (8, 'ADP654'); 

--TRANSPORTE MARITIMO
INSERT INTO TransportesMaritimos (id_transporte, registro_maritimo)
VALUES (2, 'LAN789'); -- Lancha rápida
INSERT INTO TransportesMaritimos (id_transporte, registro_maritimo)
VALUES (7, 'YAT456'); -- Yate privado
INSERT INTO TransportesMaritimos (id_transporte, registro_maritimo)
VALUES (9, 'BOAT99'); -- Supuesto barco turístico


--APROBACIONES INTERNAS GUIAS
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (2, 2, '2025-11-06');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (3, 1, '2025-11-06');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (1, 8, '2025-11-06');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (2, 9, '2025-11-06');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (3, 10, '2025-11-06');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (1, 11, '2025-11-06');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (1, 12, '2025-11-01');
INSERT INTO AprobacionesInternasGuias (id_aprobacion, id_guia, fecha_establecimiento_estado)
VALUES (2, 13, '2025-11-05');


--GUIAS IDIOMAS
-- Guía de ciudad (id_persona = 11) habla Español e Inglés
INSERT INTO GuiasIdiomas (id_persona, id_idioma) VALUES (11, 1);
INSERT INTO GuiasIdiomas (id_persona, id_idioma) VALUES (11, 2);
-- Guía de montaña (id_persona = 10) habla Español e Italiano
INSERT INTO GuiasIdiomas (id_persona, id_idioma) VALUES (10, 1);
INSERT INTO GuiasIdiomas (id_persona, id_idioma) VALUES (10, 5);

--GUIAS TOUR
-- Guía de ciudad (id_persona = 11) asignado a Tour 7 (Español) y Tour 8 (Inglés)
INSERT INTO GuiasTours (id_persona, id_tour) VALUES (11, 1);
INSERT INTO GuiasTours (id_persona, id_tour) VALUES (11, 2);
-- Guía de montaña (id_persona = 33) asignado a Tour 9 (Francés) y Tour 11 (Italiano)
INSERT INTO GuiasTours (id_persona, id_tour) VALUES (22, 6);


select * from GuiasTours

--ESTADOS TRANSPORTADORAS
-- Estado activo
INSERT INTO EstadosTransportadoras (id_estado_transportadora, nombre_estado, descripcion)
VALUES (1, 'ACTIVO', 'Disponible');
-- Estado inactivo
INSERT INTO EstadosTransportadoras (id_estado_transportadora, nombre_estado, descripcion)
VALUES (2, 'INACTIVO', 'Suspendido');

--ESTADOS TRANSPORTADORA TRANSPORTADORAS
-- Transportadora 1 activa
INSERT INTO EstadosTransportadoraTransportadoras (id_estado_transportadora, id_transportadora, fecha_establecimiento_estado)
VALUES (1, 1, '2025-11-10');
-- Transportadora 2 activa
INSERT INTO EstadosTransportadoraTransportadoras (id_estado_transportadora, id_transportadora, fecha_establecimiento_estado)
VALUES (1, 2, '2025-11-10');
-- Transportadora 3 inactiva
INSERT INTO EstadosTransportadoraTransportadoras (id_estado_transportadora, id_transportadora, fecha_establecimiento_estado)
VALUES (2, 3, '2025-11-11');
-- Transportadora 4 activa
INSERT INTO EstadosTransportadoraTransportadoras (id_estado_transportadora, id_transportadora, fecha_establecimiento_estado)
VALUES (1, 4, '2025-11-12');
-- Transportadora 5 inactiva
INSERT INTO EstadosTransportadoraTransportadoras (id_estado_transportadora, id_transportadora, fecha_establecimiento_estado)
VALUES (2, 5, '2025-11-12');

--ESTADOS TRANSPORTE
-- Estado activo
INSERT INTO EstadosTransportes (nombre_estado, descripcion)
VALUES ('ACTIVO', 'Disponible');
-- Estado inactivo
INSERT INTO EstadosTransportes (nombre_estado, descripcion)
VALUES ('INACTIVO', 'Suspendido');
 
 --ESTADO TRANSPORTE TRANSPORTES
 -- Bus turístico (id_transporte = 6) activo
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (1, 6, '2025-11-10');
-- Lancha rápida (id_transporte = 7) activa
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (1, 7, '2025-11-10');
-- Avión charter (id_transporte = 8) inactivo
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (2, 8, '2025-11-11');
-- Camioneta 4x4 (id_transporte = 9) activa
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (1, 9, '2025-11-12');
-- Buseta urbana (id_transporte = 10) inactiva
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (2, 10, '2025-11-12');
-- Helicóptero turístico (id_transporte = 11) activo
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (1, 5, '2025-11-13');
-- Yate privado (id_transporte = 12) activo
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (1, 4, '2025-11-13');
-- Camión de carga (id_transporte = 13) inactivo
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (2, 3, '2025-11-14');
-- Bote fluvial (id_transporte = 14) activo
INSERT INTO EstadosTransporteTransportes (id_estado_transporte, id_transporte, fecha_establecimiento_estado)
VALUES (1, 2, '2025-11-14');


--ESTADOS ETIQUETAS
-- Estado activo
INSERT INTO EstadosEtiquetas (nombre_estado, descripcion)
VALUES ('ACTIVO', 'Disponible');
-- Estado inactivo
INSERT INTO EstadosEtiquetas (nombre_estado, descripcion)
VALUES ('INACTIVO', 'Suspendido');

--ETIQUETAS PREDEFINIDAS
-- Etiqueta activa
INSERT INTO EtiquetasPredefinidas (descripcion, id_estado_etiqueta, fecha_estado_actual)
VALUES ('Promoción Especial', 1, '2025-11-15');
-- Etiqueta inactiva
INSERT INTO EtiquetasPredefinidas (descripcion, id_estado_etiqueta, fecha_estado_actual)
VALUES ('Oferta Expirada', 2, '2025-11-14');
-- Otra etiqueta activa
INSERT INTO EtiquetasPredefinidas (descripcion, id_estado_etiqueta, fecha_estado_actual)
VALUES ('Nuevo Lanzamiento', 1, '2025-11-16');
-- Otra etiqueta inactiva
INSERT INTO EtiquetasPredefinidas (descripcion, id_estado_etiqueta, fecha_estado_actual)
VALUES ('Descontinuado', 2, '2025-11-13');

--ETIQUETAS RESENAS
-- Reseña 7 marcada como Promoción Especial y Nuevo Lanzamiento
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (5, 1);
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (5, 3);
-- Reseña 8 marcada como Oferta Expirada
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (9, 2);
-- Reseña 9 marcada como Nuevo Lanzamiento
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (9, 3);
-- Reseña 10 marcada como Descontinuado
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (11, 4);
-- Reseña 11 marcada como Promoción Especial
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (11, 1);
-- Reseña 12 marcada como Oferta Expirada y Descontinuado
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (12, 2);
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (12, 4);
-- Reseña 13 marcada como Nuevo Lanzamiento
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (15, 3);
-- Reseña 14 marcada como Promoción Especial
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (15, 1);
-- Reseña 15 marcada como Descontinuado
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (15, 4);
-- Reseña 16 marcada como Oferta Expirada
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (16, 2);
-- Reseña 17 marcada como Nuevo Lanzamiento
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (19, 3);
-- Reseña 18 marcada como Promoción Especial
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (19, 1);
-- Reseña 19 marcada como Oferta Expirada
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (19, 2);
-- Reseña 20 marcada como Descontinuado
INSERT INTO ResenasEtiquetas (id_resena, id_etiqueta) VALUES (20, 4);

--TIPO MULTIMEDIA
-- Tipo multimedia para reseñas
INSERT INTO TiposMultimedia (nombre)
VALUES ('MULTIMEDIA RESEÑA');
-- Tipo multimedia para tours
INSERT INTO TiposMultimedia (nombre)
VALUES ('MULTIMEDIA TOUR');

--TIPO MULTIMEDIA MULTIMEDIAS
-- Multimedia reseña (tipo 1) asociado a multimedias 1, 2 y 3
INSERT INTO TiposMultimediaMultimedia (id_tipo_multimedia, id_multimedia) VALUES (1, 1);
INSERT INTO TiposMultimediaMultimedia (id_tipo_multimedia, id_multimedia) VALUES (1, 2);
INSERT INTO TiposMultimediaMultimedia (id_tipo_multimedia, id_multimedia) VALUES (1, 3);
-- Multimedia tour (tipo 2) asociado a multimedias 4, 5 y 6
INSERT INTO TiposMultimediaMultimedia (id_tipo_multimedia, id_multimedia) VALUES (2, 4);
INSERT INTO TiposMultimediaMultimedia (id_tipo_multimedia, id_multimedia) VALUES (2, 5);
INSERT INTO TiposMultimediaMultimedia (id_tipo_multimedia, id_multimedia) VALUES (2, 6);

--TURISTAS GRUPOS

-- Grupo Playa (id_grupo = 1)
INSERT INTO TuristasGrupos (id_turista, id_grupo) VALUES (1, 1);
INSERT INTO TuristasGrupos (id_turista, id_grupo) VALUES (3, 2);
INSERT INTO TuristasGrupos (id_turista, id_grupo) VALUES (4, 3);
-- Grupo Centro (id_grupo = 2)
INSERT INTO TuristasGrupos (id_turista, id_grupo) VALUES (13, 4);
INSERT INTO TuristasGrupos (id_turista, id_grupo) VALUES (14, 5);


select * from grupos

-- Tour 7 con precio 1 vigente desde el 1 de noviembre
INSERT INTO PreciosTours (id_precio, id_tour, fecha_inicio_vigencia, fecha_fin_vigencia)
VALUES (1, 7, '2025-11-01', NULL);

-- Tour 8 con precio 2 vigente desde el 5 de noviembre hasta el 15
INSERT INTO PreciosTours (id_precio, id_tour, fecha_inicio_vigencia, fecha_fin_vigencia)
VALUES (2, 2, '2025-11-05', '2025-11-15');

-- Tour 9 con precio 3 vigente desde el 10 de noviembre
INSERT INTO PreciosTours (id_precio, id_tour, fecha_inicio_vigencia, fecha_fin_vigencia)
VALUES (3, 1, '2025-11-10', NULL);

-- Tour 10 con precio 1 vigente desde el 12 al 20 de noviembre
INSERT INTO PreciosTours (id_precio, id_tour, fecha_inicio_vigencia, fecha_fin_vigencia)
VALUES (1, 15, '2025-11-12', '2025-11-20');

-- Tour 11 con precio 2 vigente desde el 15 de noviembre
INSERT INTO PreciosTours (id_precio, id_tour, fecha_inicio_vigencia, fecha_fin_vigencia)
VALUES (2, 16, '2025-11-15', NULL);
