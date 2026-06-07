CREATE TABLE Ciudades (
	id_ciudad int IDENTITY(1,1),
	nombre nvarchar(40) NOT NULL,
	
	PRIMARY KEY ([id_ciudad]),
	CONSTRAINT UQ_ciudades_nombre UNIQUE(nombre),
	CONSTRAINT CK_ciudades_nombre CHECK (TRIM(nombre) <> '')
);

CREATE TABLE TiposPersonas(
	id_tipo_persona INT IDENTITY(1,1),
	nombre NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_tipo_persona PRIMARY KEY (id_tipo_persona)
);

ALTER TABLE TiposPersonas
ADD CONSTRAINT CK_TiposPersonas_nombre
CHECK (UPPER(nombre) IN ('GUIA','TURISTA'));


CREATE TABLE [Personas] (
	[id_persona] int IDENTITY(1,1),
	[nombre] nvarchar(50) NOT NULL,
	[direccion] nvarchar(30) NOT NULL,
	[telefono] nvarchar(15) NOT NULL,
	[documento_identidad] nvarchar(20) NOT NULL, --especificar en la historia de usuario que puede ser cedula (colombia) o pasaporte (internacional)
	[fecha_nacimiento] date NOT NULL,
	[email] nvarchar(50) NOT NULL,
	id_tipo_persona INT NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_personas PRIMARY KEY ([id_persona]),
	CONSTRAINT UQ_personas_documento_identidad UNIQUE (documento_identidad),
	CONSTRAINT UQ_personas_email UNIQUE (email),
	CONSTRAINT CK_email CHECK (email LIKE '%@%.%' AND email NOT LIKE '% %'),   
	CONSTRAINT CK_documento_identidad CHECK (documento_identidad NOT LIKE '% %'
	AND LEN(documento_identidad) BETWEEN 6 AND 20 AND documento_identidad NOT LIKE '%[^A-Z0-9]%'),--solo acepta letras mayusculas A-Z y numeros 0-9
	 CONSTRAINT CK_telefono CHECK (telefono NOT LIKE '%[^0-9]%' AND LEN(telefono) BETWEEN 7 AND 15),
	CONSTRAINT CK_nombre CHECK (TRIM(nombre) <> ''),
	CONSTRAINT FK_id_tipo_persona FOREIGN KEY (id_tipo_persona) REFERENCES TiposPersonas(id_tipo_persona)

);
ALTER TABLE Personas
ADD apellido NVARCHAR(50) NULL
    CONSTRAINT CK_apellido CHECK (TRIM(apellido) <> '');


CREATE TABLE [EstadosCategorias] (
	[id_estado_categoria] INT IDENTITY(1,1),
	[nombre_estado] NVARCHAR(20) NOT NULL,
	[descripcion] NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_estados_categorias PRIMARY KEY ([id_estado_categoria]),
	CONSTRAINT CK_EstadosCategorias_nombre CHECK ((nombre_estado) IN ('ACTIVO', 'INACTIVO'))
);


CREATE TABLE [CategoriasTours] (
	[fecha_estado_actual] date NOT NULL,
	[id_categoria_tour] int IDENTITY(1,1),
	[nombre] nvarchar(18) NOT NULL UNIQUE DEFAULT 'PENDIENTE POR CLASIFICACION',
	[descripcion] nvarchar(50) NOT NULL,
	[icono] nvarchar(255) NOT NULL, -- pasó de 60 a 255
	[id_estado_categoria] int NOT NULL,
	PRIMARY KEY ([id_categoria_tour]),
	CONSTRAINT [CategoriaTour_fk5] FOREIGN KEY ([id_estado_categoria]) REFERENCES [EstadosCategorias]([id_estado_categoria]),
	CONSTRAINT CK_Icono_extension CHECK (icono LIKE '%.png' OR icono LIKE '%.jpg'), --solo archivos .png y .jpg
	CONSTRAINT CK_nombres_tours CHECK (TRIM(nombre) <> ''),
	CONSTRAINT CK_descripcion CHECK (TRIM(descripcion) <> ''),
	CONSTRAINT CK_Fecha_No_Futura
		CHECK ([fecha_estado_actual] <= GETDATE())
);

CREATE TABLE [Guias] (
	[id_guia] int NOT NULL UNIQUE,
	[id_persona] int NOT NULL,
	descripcion_guia nvarchar(300) NOT NULL,
	[foto_perfil] nvarchar(100) NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_id_persona PRIMARY KEY ([id_persona]),
	CONSTRAINT FK_id_persona FOREIGN KEY ([id_persona]) REFERENCES [Personas](id_persona),
	CONSTRAINT CK_Extension_Foto_perfil CHECK (foto_perfil LIKE '%.png' OR foto_perfil LIKE '%.jpg'), --solo archivos .png y .jpg
	CONSTRAINT CK_descripcion_GUIA CHECK (TRIM(descripcion_guia) <> '')
);

--no hay restriccion
CREATE TABLE [Estados_tours] (
	[id_estado] int IDENTITY(1,1),
	[nombre_estado] nvarchar(60) NOT NULL DEFAULT 'INACTIVO',
	[descripcion] nvarchar(255) NOT NULL,
	PRIMARY KEY ([id_estado]),
    CONSTRAINT CK_nombre_estado_estado_tours CHECK ([nombre_estado] IN ('ACTIVO', 'INACTIVO')),
	CONSTRAINT CK_descripcion_estados_tours CHECK (TRIM(descripcion) <> ''),
	
);

CREATE TABLE [Tours] (
	[id_tour] INT IDENTITY(1,1),
	[nombre_comercial] NVARCHAR(50) NOT NULL,
	[descripcion] NVARCHAR(500) NOT NULL,
	[fecha_estado_actual] DATE NOT NULL,
	[id_categoria_tour] INT NOT NULL DEFAULT 1,
	[id_estado] INT NOT NULL DEFAULT 1,
	[id_guia] INT NOT NULL DEFAULT 1,
	[capacidad_maxima] INT NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_tours PRIMARY KEY ([id_tour]),
	CONSTRAINT [Tours_fk5] FOREIGN KEY ([id_categoria_tour]) REFERENCES [CategoriasTours]([id_categoria_tour]) ON DELETE SET DEFAULT,
	CONSTRAINT [Tours_fk6] FOREIGN KEY ([id_estado]) REFERENCES [Estados_tours]([id_estado]) ON DELETE SET DEFAULT,
	CONSTRAINT [Tours_fk7] FOREIGN KEY ([id_guia]) REFERENCES [Guias]([id_guia]) ,


	-- Nombre comercial no puede ser solo espacios
	CONSTRAINT CK_NombreComercial_NoVacio_tours
		CHECK (LTRIM(RTRIM([nombre_comercial])) <> ''),

	-- Descripción no puede estar vacía
	CONSTRAINT CK_Descripcion_NoVacia_tours
		CHECK (LTRIM(RTRIM([descripcion])) <> ''),

	-- Fecha no puede ser futura
	CONSTRAINT CK_Fecha_NoFutura_tours
		CHECK ([fecha_estado_actual] <= GETDATE()),

	-- Capacidad máxima debe ser positiva
	CONSTRAINT CK_Capacidad_Positive_tours
		CHECK ([capacidad_maxima] > 0),

	-- Capacidad debe ser razonable (ej: no tours de 3000 personas)
	CONSTRAINT CK_Capacidad_Realista_tours
		CHECK ([capacidad_maxima] BETWEEN 1 AND 1000), 
);


--no hay restriccion
CREATE TABLE [Turistas] (	
	[id_ciudad_nacimiento] int NOT NULL,
	[id_persona] int NOT NULL,
	[codigo_turista] int NOT NULL UNIQUE,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_turistas PRIMARY KEY ([id_persona]),
	CONSTRAINT [Turista_fk0] FOREIGN KEY ([id_ciudad_nacimiento]) REFERENCES [Ciudades]([id_ciudad]),
	CONSTRAINT [Turista_fk2] FOREIGN KEY ([id_persona]) REFERENCES [Personas]([id_persona]),
	CONSTRAINT UQ_turistas_codigo_turistas UNIQUE(codigo_turista)
);

--no hay restriccion
CREATE TABLE [Disponibilidades] (
	[fecha_disponibilidad] date NOT NULL,
	[hora_disponibilidad] time(7) NOT NULL,
	[id_disponibilidad] int IDENTITY(1,1),
	CONSTRAINT PK_disponibilidades PRIMARY KEY ([id_disponibilidad]),
	CONSTRAINT CK_Fecha_No_Pasada_disponibilidades
		CHECK ([fecha_disponibilidad] >= CAST(GETDATE() AS DATE))
);

CREATE TABLE TiposTransportes(
	id_tipo_transporte INT IDENTITY(1,1),
	nombre NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_tipo_transporte PRIMARY KEY (id_tipo_transporte)
);

--no hay restriccion
CREATE TABLE [PuntosEncuentros] (
	[id_punto_encuentro] int IDENTITY(1,1),
	[direccion] nvarchar(100) NOT NULL UNIQUE,
	[lat] decimal(9,6) NOT NULL,
	[lon] decimal(9,6) NOT NULL,
	PRIMARY KEY ([id_punto_encuentro]),
	CONSTRAINT CK_Direccion_NoVacia_puntos_encuentro CHECK (LTRIM(RTRIM([direccion])) <> ''),
	CONSTRAINT CK_Lat_Rango CHECK ([lat] BETWEEN -90 AND 90),
	CONSTRAINT CK_Lon_Rango CHECK ([lon] BETWEEN -180 AND 180)
);

--no hay restriccion, por que solo hay una descripcion? que pasa con los archivos que suben los turistas?
CREATE TABLE [Multimedias] (
	[id_multimedia] int IDENTITY(1,1),
	[limite_tamanio] int NOT NULL,
	[descripcion] nvarchar(200) NOT NULL,
	PRIMARY KEY ([id_multimedia]),
	CONSTRAINT CK_Limite_Tamanio_Positive_multimedias CHECK ([limite_tamanio] > 0),
	CONSTRAINT CK_Descripcion_NoVacia_multimedias CHECK (LTRIM(RTRIM([descripcion])) <> '')
);

--no hay restriccion
CREATE TABLE [Tours_Multimedias] (
	[archivo_video] nvarchar(max) NOT NULL,
	[id_multimedia] int NOT NULL,
	PRIMARY KEY ([id_multimedia]),
	CONSTRAINT Tour_Multimedia_fk2 FOREIGN KEY (id_multimedia) REFERENCES [Multimedias](id_multimedia),
	CONSTRAINT CK_ArchivoVideo_NoVacio_tours_multimedia CHECK (LTRIM(RTRIM([archivo_video])) <> ''),
	CONSTRAINT CK_ArchivoVideo_Extension_tours_multimedia CHECK (
		LOWER([archivo_video]) LIKE '%.mp4' OR LOWER([archivo_video]) LIKE '%.jpeg')
);

--no hay restriccion
CREATE TABLE [Sugerencias] (
	[id_sugerencia] INT IDENTITY(1,1),
	[id_tour] INT NOT NULL,
	[descripcion] NVARCHAR(200) NOT NULL,
	[fecha] DATE NOT NULL,
	CONSTRAINT PK_sugerencias PRIMARY KEY ([id_sugerencia]),
	CONSTRAINT Sugerencia_fk1 FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT CK_Descripcion_NoVacia_sugerencias CHECK (LTRIM(RTRIM([descripcion])) <> ''),
	CONSTRAINT CK_Fecha_NoFutura_sugerencias CHECK ([fecha] <= CAST(GETDATE() AS DATE))
);

CREATE TABLE [Idiomas] (
	[id_idioma] int IDENTITY(1,1),
	[nombre] nvarchar(15) NOT NULL,
	[codigo_idioma] char(2) NOT NULL,
	CONSTRAINT PK_idiomas PRIMARY KEY ([id_idioma]),
	CONSTRAINT UQ_idiomas_codigo_idioma UNIQUE(codigo_idioma),
	CONSTRAINT CK_Codigo_idiomas CHECK(codigo_idioma NOT LIKE '%[^A-Za-z]%'), --codigo  ISO 639‑2 
	CONSTRAINT CK_nombre_idiomas CHECK (TRIM(nombre) <> '')
);


CREATE TABLE [Tours_Idiomas] (
	[id_tour] int NOT NULL,
	[id_idioma] int NOT NULL,
	CONSTRAINT PK_tours_idiomas PRIMARY KEY ([id_tour], [id_idioma]),
	CONSTRAINT FK_tours_idiomas FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT [Tour_Idioma_fk1] FOREIGN KEY ([id_idioma]) REFERENCES [Idiomas]([id_idioma])
);


CREATE TABLE [Transportadoras] (
	[id_transportadora] INT IDENTITY(1,1),
	[nombre] NVARCHAR(20) NOT NULL,
	[telefono] NVARCHAR(10) NOT NULL,
	[nit] NVARCHAR(10) NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_transportadoras PRIMARY KEY ([id_transportadora]),
	CONSTRAINT UQ_transportadoras_nit UNIQUE ([nit]),
	CONSTRAINT CK_nombre_NoVacio_transportadora CHECK (LTRIM(RTRIM([nombre])) <> ''),
	CONSTRAINT CK_nombre_Largo_transportadora CHECK (LEN([nombre]) BETWEEN 3 AND 20),
	CONSTRAINT CK_telefono_transportadoras CHECK ([telefono] NOT LIKE '%[^0-9]%' AND LEN([telefono]) BETWEEN 7 AND 10),
	CONSTRAINT CK_nit_transportadoras CHECK ([nit] NOT LIKE '%[^0-9]%' AND LEN([nit]) BETWEEN 9 AND 10)
);



CREATE TABLE [Transportes] (
	[id_transporte] INT IDENTITY(1,1),
	[id_transportadora] INT NOT NULL,
	[descripcion] NVARCHAR(150) NOT NULL,
	id_tipo_transporte INT NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_transportes PRIMARY KEY ([id_transporte]),
	CONSTRAINT Transporte_fk1 FOREIGN KEY ([id_transportadora]) REFERENCES [Transportadoras]([id_transportadora]) ON DELETE CASCADE,
	CONSTRAINT FK_id_tipo_transporte FOREIGN KEY (id_tipo_transporte) REFERENCES TiposTransportes(id_tipo_transporte) ON DELETE CASCADE,
	CONSTRAINT CK_Descripcion_NoVacia_transportes CHECK (LTRIM(RTRIM([descripcion])) <> ''),
	CONSTRAINT CK_Descripcion_Largo_transportes CHECK (LEN([descripcion]) BETWEEN 5 AND 150),
);


CREATE TABLE [EstadosPagos] (
	[id_estado_pago] INT IDENTITY(1,1),
	[nombre_estado] NVARCHAR(60) NOT NULL DEFAULT 'PENDIENTE',
	[descripcion] NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_estados_pagos PRIMARY KEY ([id_estado_pago]),
	CONSTRAINT CK_NombreEstado_NoVacio_estados_pagos CHECK (LTRIM(RTRIM([nombre_estado])) <> ''),
	CONSTRAINT CK_Descripcion_NoVacia_estados_pagos CHECK (LTRIM(RTRIM([descripcion])) <> ''),
	CONSTRAINT CK_nombre_estado_estado_pago CHECK ([nombre_estado] IN ('PAGO', 'ABONO', 'PENDIENTE')),

);

CREATE TABLE [PagosReservas] (
	[fecha_estado_actual] date NOT NULL,
	[id_pago] int IDENTITY(1,1),
	[fecha_pago] date NOT NULL,
	[metodo_pago] nvarchar(20) NOT NULL,
	[monto_total] decimal(18,0) NOT NULL,
	[id_estado_pago] int NOT NULL DEFAULT 1,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	PRIMARY KEY ([id_pago]),
	CONSTRAINT [Pago_Reserva_fk5] FOREIGN KEY ([id_estado_pago]) REFERENCES [EstadosPagos]([id_estado_pago]) ON DELETE SET DEFAULT,
	CONSTRAINT CK_fecha_pago_reservas CHECK (fecha_pago <= GETDATE()),
    CONSTRAINT CK_fecha_estado_pago_reservas CHECK (fecha_estado_actual >= fecha_pago),
    CONSTRAINT CK_monto_total_pagos_reservas CHECK (monto_total > 0 AND monto_total < 1000000000),
    CONSTRAINT CK_metodo_pago_reservas_pagos CHECK (metodo_pago IN ('EFECTIVO','TARJETA','TRANSFERENCIA'))
);


CREATE TABLE [EstadosReservas] (
	[id_estado_reserva] INT NOT NULL,
	[nombre_estado] NVARCHAR(20) NOT NULL,
	[descripcion] NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY ([id_estado_reserva]),
	CONSTRAINT CK_NombreEstado_NoVacio_estados_Reservas CHECK (LTRIM(RTRIM([nombre_estado])) <> ''),
	CONSTRAINT CK_Descripcion_NoVacia_estados_reservas CHECK (LTRIM(RTRIM([descripcion])) <> ''),
	CONSTRAINT CK_Estados_Reservas CHECK (nombre_estado IN ('COMPLETADA','CONFIRMADA','PENDIENTE', 'CANCELADA'))
);



CREATE TABLE [ToursCiudades] (
	[id_tour] int NOT NULL,
	[id_ciudad] int NOT NULL,
	CONSTRAINT PK_tours_ciudades PRIMARY KEY ([id_tour], [id_ciudad]),
	CONSTRAINT [ToursCiudades_fk0] FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT [ToursCiudades_fk1] FOREIGN KEY ([id_ciudad]) REFERENCES [Ciudades]([id_ciudad])
);

CREATE TABLE [EstadosGrupos] (
	[id_estado_grupo] INT IDENTITY(1,1),
	[nombre_estado] NVARCHAR(20) NOT NULL DEFAULT 'ABIERTO' ,
	[descripcion] NVARCHAR(20) NOT NULL,
	PRIMARY KEY ([id_estado_grupo]),
	CONSTRAINT CK_NombreEstado_NoVacio_estados_grupos CHECK (LTRIM(RTRIM([nombre_estado])) <> ''),
	CONSTRAINT CK_Descripcion_NoVacia_estados_grupos CHECK (LTRIM(RTRIM([descripcion])) <> ''),
	CONSTRAINT CK_NombreEstado_Largo_estados_grupos CHECK (LEN([nombre_estado]) BETWEEN 3 AND 20),
	CONSTRAINT CK_Descripcion_Largo_estados_grupos CHECK (LEN([descripcion]) BETWEEN 3 AND 20),
	CONSTRAINT CH_Estados_Del_Grupo CHECK ([nombre_estado] IN ('ABIERTO','CERRADO'))
);


CREATE TABLE [Grupos] (
	[id_grupo] INT IDENTITY(1,1),
	[id_guia] INT NOT NULL,
	[nombre] NVARCHAR(60) NOT NULL,
	[hora_salida] TIME(7) NOT NULL,
	[capacidad_maxima] INT NOT NULL,
	[id_estado_grupo] INT NOT NULL DEFAULT 1,
	[fecha_estado_actual] DATE NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_grupos PRIMARY KEY ([id_grupo]),
	CONSTRAINT Grupo_fk1 FOREIGN KEY ([id_guia]) REFERENCES [Guias]([id_guia]) ON DELETE CASCADE,
	CONSTRAINT Grupo_fk5 FOREIGN KEY ([id_estado_grupo]) REFERENCES [EstadosGrupos]([id_estado_grupo]) ON DELETE SET DEFAULT,
	CONSTRAINT CK_Nombre_NoVacio_grupos CHECK (LTRIM(RTRIM([nombre])) <> ''),
	CONSTRAINT CK_Nombre_Largo_grupos CHECK (LEN([nombre]) BETWEEN 3 AND 60),
	CONSTRAINT CK_HoraSalida_Rango_grupos CHECK ([hora_salida] BETWEEN '05:00:00' AND '23:00:00'),
	CONSTRAINT CK_Capacidad_Positive_grupos CHECK ([capacidad_maxima] > 0),
	CONSTRAINT CK_Capacidad_Realista_grupos CHECK ([capacidad_maxima] BETWEEN 1 AND 200),
	CONSTRAINT CK_Fecha_NoFutura_grupos CHECK ([fecha_estado_actual] <= CAST(GETDATE() AS DATE))
);




CREATE TABLE [TuristasGrupos] (
	[id_turista] int NOT NULL,
	[id_grupo] int NOT NULL,
	CONSTRAINT PK_turistasgrupos PRIMARY KEY (id_turista,id_grupo),
	CONSTRAINT FK_turistasgrupos FOREIGN KEY (id_turista) REFERENCES Turistas(id_persona),
	CONSTRAINT FK_id_grupo FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo)
	);

CREATE TABLE [AprobacionesInternas] (
	[id_aprobacion] INT IDENTITY(1,1),
	[nombre_estado] NVARCHAR(60) NOT NULL DEFAULT 'EN PROCESO DE VERIFICACION',
	PRIMARY KEY ([id_aprobacion]),
	CONSTRAINT CK_AprobacionesInternas_Estados CHECK (
		[nombre_estado] IN (
			'EN PROCESO DE VERIFICACION',
			'VERIFICADO',
			'NO VERIFICADO'
		)
	)
);

CREATE TABLE [AprobacionesInternasGuias] (
	[id_aprobacion] int NOT NULL,
	[id_guia] int NOT NULL,
	[fecha_establecimiento_estado] date NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT PK_aprobaciones_internas_guias PRIMARY KEY ([id_aprobacion], [id_guia]),
	CONSTRAINT [Aprobacion_interna_guia_fk0] FOREIGN KEY ([id_aprobacion]) REFERENCES [AprobacionesInternas]([id_aprobacion]),
	CONSTRAINT [Aprobacion_interna_guia_fk1] FOREIGN KEY ([id_guia]) REFERENCES [Guias]([id_guia])

);

CREATE TABLE [Precios] (
	[id_precio] INT NOT NULL,
	[precio] DECIMAL(12,2) NOT NULL,
	[moneda] NVARCHAR(MAX) NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_precios PRIMARY KEY ([id_precio]),
	CONSTRAINT CK_Precio_Positive CHECK ([precio] > 0),
	CONSTRAINT CK_Moneda_NoVacia CHECK (LTRIM(RTRIM([moneda])) <> '')
);

-- Crear la secuencia
CREATE SEQUENCE Seq_Precios
    START WITH 1
    INCREMENT BY 1;

-- Ajustar la columna para usar la secuencia
ALTER TABLE Precios
ADD CONSTRAINT DF_id_precio DEFAULT NEXT VALUE FOR Seq_Precios FOR id_precio;

ALTER TABLE Precios
ALTER COLUMN precio DECIMAL(12,2) NOT NULL;



CREATE TABLE [PreciosTours] (
	[id_precio] INT NOT NULL,
	[id_tour] INT NOT NULL,
	[fecha_inicio_vigencia] DATE NOT NULL,
	[fecha_fin_vigencia] DATE NULL,
	CONSTRAINT PK_precios_tours PRIMARY KEY ([id_precio], [id_tour]),
	CONSTRAINT Precios_tours_fk0 FOREIGN KEY ([id_precio]) REFERENCES [Precios]([id_precio]),
	CONSTRAINT Precios_tours_fk1 FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),

	CONSTRAINT CK_Fechas_NoVacias_precios_tours CHECK ([fecha_inicio_vigencia] IS NOT NULL),
	CONSTRAINT CK_Fechas_Orden_precios_tours CHECK (
		[fecha_fin_vigencia] IS NULL 
		OR [fecha_fin_vigencia] >= [fecha_inicio_vigencia]
	)
);

CREATE TABLE [Logisticas] (
	[id_logistica] int IDENTITY(1,1),
	[id_tour] int NOT NULL,
	[itinerario] nvarchar(1000) NOT NULL,
	[duracion_estimado] time(7) NOT NULL,
	[id_punto_encuentro] int NOT NULL,
	CONSTRAINT PK_logistica PRIMARY KEY ([id_logistica]),
	CONSTRAINT [Logistica_fk1] FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT [Logistica_fk4] FOREIGN KEY ([id_punto_encuentro]) REFERENCES [PuntosEncuentros]([id_punto_encuentro]),
	CONSTRAINT CK_Itinerario_NoVacio_logisticas CHECK (LTRIM(RTRIM([itinerario])) <> ''),
	CONSTRAINT CK_Itinerario_Largo_logisticas CHECK (LEN([itinerario]) BETWEEN 10 AND 1000)
);

CREATE TABLE LogisticaTransporte(
	id_logistica int NOT NULL,
	id_transporte int NOT NULL,
	fecha_finalizacion date default NULL,
	CONSTRAINT PK_logistica_transporte PRIMARY KEY(id_logistica,id_transporte),
	CONSTRAINT FK_logistica_transporte_logistica FOREIGN KEY(id_logistica) REFERENCES Logisticas(id_logistica),
	CONSTRAINT FK_logistica_transporte_transporte FOREIGN KEY(id_transporte) REFERENCES Transportes(id_transporte)
);

CREATE TABLE [DisponibilidadesTours] (
	[id_tour] INT NOT NULL,
	[id_disponibilidad] INT NOT NULL,
	[fecha_inicio_disponibilidad] DATE NOT NULL,
	[fecha_fin_disponibilidad] DATE NULL,

	CONSTRAINT PK_disponibilidades_tours 
		PRIMARY KEY ([id_tour], [id_disponibilidad]),
	CONSTRAINT DisponibilidadesTours_fk0 FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT DisponibilidadesTours_fk1 FOREIGN KEY ([id_disponibilidad]) REFERENCES [Disponibilidades]([id_disponibilidad]),
	CONSTRAINT CK_FechaInicio_NoVacia_disponibilidades_tours 
		CHECK ([fecha_inicio_disponibilidad] IS NOT NULL),
	CONSTRAINT CK_Fechas_Orden_disponibilidades_tours
		CHECK (
			[fecha_fin_disponibilidad] IS NULL
			OR [fecha_fin_disponibilidad] >= [fecha_inicio_disponibilidad])
);


CREATE TABLE [Resenas] (
	[id_resena] int IDENTITY(1,1),
	[id_tour] int NOT NULL,
	[id_persona] int NOT NULL,
	[fecha] date NOT NULL,
	[texto] nvarchar(255),
	[calificacion] int NOT NULL,
	CONSTRAINT PK_resenas PRIMARY KEY ([id_resena]),
	CONSTRAINT [Resena_fk1] FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT [Resena_fk22] FOREIGN KEY ([id_persona]) REFERENCES [Personas]([id_persona])
);

CREATE TABLE [Multimedias_resenas] (
	[id_multimedia] INT NOT NULL,
	[archivo] NVARCHAR(MAX) NOT NULL,
	[fecha_subida] DATE NOT NULL,
	[formato] NVARCHAR(10) NOT NULL,
	[tamanio_archivo] INT NOT NULL,
	PRIMARY KEY ([id_multimedia]),
	CONSTRAINT Multimedia_resena_fk1 FOREIGN KEY ([id_multimedia]) REFERENCES [Multimedias]([id_multimedia]),
	CONSTRAINT CK_Archivo_NoVacio_multimedia_resenas CHECK (LTRIM(RTRIM([archivo])) <> ''),
	CONSTRAINT CK_FechaSubida_NoFutura_multimedias_resenas CHECK ([fecha_subida] <= CAST(GETDATE() AS DATE)),
	CONSTRAINT CK_Formato_archivo CHECK (formato LIKE '%.png' OR formato LIKE '%.jpg'),
	CONSTRAINT CK_Tamanio_Positive_multimedias_resenas CHECK ([tamanio_archivo] > 0)
);

CREATE TABLE [Multimedias_tour_Tours] (
	[id_tour_multimedia] INT NOT NULL,
	[id_tour] INT NOT NULL,
	CONSTRAINT PK_multimedias_tour_tours 
		PRIMARY KEY ([id_tour_multimedia], [id_tour]),
	CONSTRAINT Multimedia_tour_Tours_fk0 
		FOREIGN KEY ([id_tour_multimedia]) REFERENCES [Tours_Multimedias]([id_multimedia]),
	CONSTRAINT Multimedia_tour_Tours_fk1 
		FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]),
	CONSTRAINT CK_TourMultimedia_NoRepetido 
		UNIQUE ([id_tour_multimedia], [id_tour])
);


CREATE TABLE [Multimedias_resena_Resenas] (
	[id_resena_multimedia] int NOT NULL,
	[id_resena] int NOT NULL,
	PRIMARY KEY ([id_resena_multimedia], [id_resena]),
	CONSTRAINT [Multimedia_resena_Resenas_fk0] FOREIGN KEY ([id_resena_multimedia]) REFERENCES [Multimedias_resenas]([id_multimedia]),
	CONSTRAINT [Multimedia_resena_Resenas_fk1] FOREIGN KEY ([id_resena]) REFERENCES [Resenas]([id_resena])
);

CREATE TABLE [TransportesAereos] (
	[id_transporte] INT NOT NULL,
	[matricula_aerea] NVARCHAR(8) NOT NULL UNIQUE,
	PRIMARY KEY ([id_transporte]),
	CONSTRAINT TransporteAereo_fk0 FOREIGN KEY ([id_transporte]) REFERENCES [Transportes]([id_transporte]),
	CONSTRAINT CK_matricula_aerea_formato CHECK (matricula_aerea NOT LIKE '%[^A-Z0-9]%')
);


CREATE TABLE [TransportesTerrestres] (
	[id_transporte] INT NOT NULL,
	[numero_placa] NVARCHAR(6) NOT NULL,
	CONSTRAINT PK_transportesterrestres PRIMARY KEY ([id_transporte]),
	CONSTRAINT TransporteTerrestre_fk0 FOREIGN KEY ([id_transporte]) REFERENCES [Transportes]([id_transporte]),
	CONSTRAINT UQ_transportesterrestres_numero_placa UNIQUE (numero_placa),
	CONSTRAINT CK_numero_placa_formato CHECK (numero_placa LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]')
);

CREATE TABLE [Reservas] (
	[fecha_estado_actual] DATE NOT NULL,
	[id_estado_reserva] INT NOT NULL,
	[id_reserva] INT IDENTITY(1,1),
	[numero_personas] INT NOT NULL,
	[id_tour] INT NOT NULL,
	[id_persona] INT NOT NULL,
	[id_grupo] INT NOT NULL,
	[monto_total] DECIMAL(12,2) NOT NULL,

	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	creada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
	fecha_modificacion DATETIME NULL,
	modificada_por VARCHAR(50) NULL

	CONSTRAINT PK_reservas PRIMARY KEY ([id_reserva]),
	CONSTRAINT Reserva_fk1 FOREIGN KEY ([id_estado_reserva]) REFERENCES [EstadosReservas]([id_estado_reserva]),
	CONSTRAINT Reserva_fk4 FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour]) ON DELETE CASCADE,
	CONSTRAINT Reserva_fk5 FOREIGN KEY ([id_persona]) REFERENCES [Turistas]([id_persona]) ON DELETE CASCADE,
	CONSTRAINT Reserva_fk6 FOREIGN KEY ([id_grupo]) REFERENCES [Grupos]([id_grupo]) ON DELETE NO ACTION,
	CONSTRAINT CK_numero_personas_reserva CHECK (numero_personas > 0),
	CONSTRAINT CK_monto_total_reserva CHECK (monto_total >= 0),
	CONSTRAINT CK_fecha_creacion_reserva CHECK (fecha_creacion <= GETDATE()),
	CONSTRAINT CK_fecha_estado_reserva CHECK (fecha_estado_actual <= GETDATE())
);






CREATE TABLE [TransportesMaritimos] (
	[id_transporte] INT NOT NULL,
	[registro_maritimo] NVARCHAR(8) NOT NULL,
	CONSTRAINT PK_transportesmaritimos PRIMARY KEY ([id_transporte]),
	CONSTRAINT TransporteMaritimo_fk0 FOREIGN KEY ([id_transporte]) REFERENCES [Transportes]([id_transporte]),
	CONSTRAINT UQ_transportesmaritimos_registro_maritimo UNIQUE (registro_maritimo),
	CONSTRAINT CK_registro_maritimo_formato CHECK (registro_maritimo NOT LIKE '%[^A-Z0-9]%' AND LEN(registro_maritimo) BETWEEN 4 AND 8)
);

CREATE TABLE [Pagos_Reserva_Reservas] (
	[id_pago] INT NOT NULL,
	[id_reserva] INT NOT NULL,
	[monto_consignado] DECIMAL(12,2) NOT NULL,
	CONSTRAINT PK_pagos_reserva_reservas PRIMARY KEY ([id_pago], [id_reserva]),
	CONSTRAINT Pago_Reserva_Reservas_fk0 FOREIGN KEY ([id_pago]) REFERENCES [PagosReservas]([id_pago]),
	CONSTRAINT Pago_Reserva_Reservas_fk1 FOREIGN KEY ([id_reserva]) REFERENCES [Reservas]([id_reserva]),
	CONSTRAINT CK_monto_consignado_pagos_reserva CHECK (monto_consignado > 0)
);





CREATE TABLE [GuiasIdiomas] (
	[id_persona] int NOT NULL,
	[id_idioma] int NOT NULL,
	PRIMARY KEY ([id_persona], [id_idioma]),
	CONSTRAINT [GuiasIdiomas_fk0] FOREIGN KEY ([id_persona]) REFERENCES [Guias]([id_persona]),
	CONSTRAINT [GuiasIdiomas_fk1] FOREIGN KEY ([id_idioma]) REFERENCES [Idiomas]([id_idioma])
);


CREATE TABLE [GuiasTours] (
	[id_persona] int NOT NULL,
	[id_tour] int NOT NULL,
	CONSTRAINT PK_guiastours PRIMARY KEY ([id_persona], [id_tour]),
	CONSTRAINT [GuiasTours_fk0] FOREIGN KEY ([id_persona]) REFERENCES [Guias]([id_persona]),
	CONSTRAINT [GuiasTours_fk1] FOREIGN KEY ([id_tour]) REFERENCES [Tours]([id_tour])
);


CREATE TABLE [EstadosTransportadoras] (
    [id_estado_transportadora] INT NOT NULL,
    [nombre_estado] NVARCHAR(20) NOT NULL,
    [descripcion] NVARCHAR(20) NOT NULL,
    PRIMARY KEY ([id_estado_transportadora]),
    CONSTRAINT CK_EstadosTransportadoras_nombre CHECK ((nombre_estado) IN ('ACTIVO', 'INACTIVO'))
);

CREATE TABLE [EstadosTransportadoraTransportadoras] (
	[id_estado_transportadora] int NOT NULL,
	[id_transportadora] int NOT NULL,
	[fecha_establecimiento_estado] date NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT PK_EstadosTransportadoraTransportadoras PRIMARY KEY ([id_estado_transportadora], [id_transportadora]),
	CONSTRAINT [EstadoTransportadoraTransportadoras_fk0] FOREIGN KEY ([id_estado_transportadora]) REFERENCES [EstadosTransportadoras]([id_estado_transportadora]),
	CONSTRAINT [EstadoTransportadoraTransportadoras_fk1] FOREIGN KEY ([id_transportadora]) REFERENCES [Transportadoras]([id_transportadora])
);

CREATE TABLE [EstadosTransportes] (
	[id_estado_transporte] INT IDENTITY(1,1),
	[nombre_estado] NVARCHAR(20) NOT NULL,
	[descripcion] NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_estados_transportes PRIMARY KEY ([id_estado_transporte]),
	CONSTRAINT CK_EstadosTransportes_nombre CHECK ((nombre_estado) IN ('ACTIVO', 'INACTIVO'))
);

CREATE TABLE [EstadosTransporteTransportes] (
	[id_estado_transporte] int NOT NULL,
	[id_transporte] int NOT NULL,
	[fecha_establecimiento_estado] date NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ([id_estado_transporte], [id_transporte]),
	CONSTRAINT [EstadoTransporteTransportes_fk0] FOREIGN KEY ([id_estado_transporte]) REFERENCES [EstadosTransportes]([id_estado_transporte]),
	CONSTRAINT [EstadoTransporteTransportes_fk1] FOREIGN KEY ([id_transporte]) REFERENCES [Transportes]([id_transporte])
);

CREATE TABLE [EstadosEtiquetas] (
	[id_estado_etiqueta] INT IDENTITY(1,1),
	[nombre_estado] NVARCHAR(20) NOT NULL,
	[descripcion] NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_estadosetiquetas PRIMARY KEY ([id_estado_etiqueta]),
	CONSTRAINT CK_EstadosEtiquetas_nombre CHECK ((nombre_estado) IN ('ACTIVO', 'INACTIVO'))
);


CREATE TABLE [EtiquetasPredefinidas] (
	[id_etiqueta] INT IDENTITY(1,1),
	[descripcion] NVARCHAR(30) NOT NULL,
	[id_estado_etiqueta] INT NOT NULL,
	[fecha_estado_actual] DATE NOT NULL,
	CONSTRAINT PK_etiquetasprededefinidas PRIMARY KEY ([id_etiqueta]),
	CONSTRAINT EtiquetaPredefinida_fk2 FOREIGN KEY (id_estado_etiqueta) REFERENCES [EstadosEtiquetas](id_estado_etiqueta),
	CONSTRAINT CK_descripcion_no_vacia_etiquetas_predefinidas CHECK (LTRIM(RTRIM(descripcion)) <> ''),
	CONSTRAINT CK_fecha_estado_valida_etiquetas_predefinidas CHECK (fecha_estado_actual <= GETDATE())
);

CREATE TABLE [ResenasEtiquetas] (
	[id_resena] int NOT NULL,
	[id_etiqueta] int NOT NULL,
	PRIMARY KEY ([id_resena], [id_etiqueta]),
	CONSTRAINT [ResenaEtiqueta_fk0] FOREIGN KEY ([id_resena]) REFERENCES [Resenas]([id_resena]),
	CONSTRAINT [ResenaEtiqueta_fk1] FOREIGN KEY ([id_etiqueta]) REFERENCES [EtiquetasPredefinidas]([id_etiqueta])
);

CREATE TABLE TiposMultimedia (
	id_tipo_multimedia int IDENTITY(1,1),
	nombre NVARCHAR(30) NOT NULL,
	CONSTRAINT PK_tipo_multimedia PRIMARY KEY (id_tipo_multimedia),
	CONSTRAINT nombre_tipos_multimedia CHECK (UPPER(nombre) IN ('MULTIMEDIA RESEÑA', 'MULTIMEDIA TOUR'))
);

CREATE TABLE TiposMultimediaMultimedia (
	id_tipo_multimedia INT NOT NULL,
	id_multimedia INT NOT NULL,
	PRIMARY KEY (id_tipo_multimedia,id_multimedia),
	CONSTRAINT FK_tipo_multimedia FOREIGN KEY (id_tipo_multimedia) REFERENCES TiposMultimedia(id_tipo_multimedia),
	CONSTRAINT FK_multimedia FOREIGN KEY (id_multimedia) REFERENCES Multimedias(id_multimedia)
);


/* ============================================================
   TABLAS HISTORIAL (SOMBRA)
   ============================================================ */

-- Personas_Historial
CREATE TABLE Personas_Historial (
    id_version_persona INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    direccion NVARCHAR(30) NOT NULL,
    telefono NVARCHAR(15) NOT NULL,
    documento_identidad NVARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email NVARCHAR(50) NOT NULL,
    id_tipo_persona INT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);
ALTER TABLE Personas_Historial
ADD apellido NVARCHAR(50) NULL


-- Guias_Historial
CREATE TABLE Guias_Historial (
    id_version_guia INT IDENTITY(1,1) PRIMARY KEY,
    id_guia INT NOT NULL,
    id_persona INT NOT NULL,
    descripcion_guia NVARCHAR(300) NOT NULL,
    foto_perfil NVARCHAR(100) NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

-- Tours_Historial
CREATE TABLE Tours_Historial (
    id_version_tour INT IDENTITY(1,1) PRIMARY KEY,
    id_tour INT NOT NULL,
    nombre_comercial NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(500) NOT NULL,
    fecha_estado_actual DATE NOT NULL,
    id_categoria_tour INT NOT NULL,
    id_estado INT NOT NULL,
    id_guia INT NOT NULL,
    capacidad_maxima INT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

-- Turistas_Historial
CREATE TABLE Turistas_Historial (
    id_version_turista INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    id_ciudad_nacimiento INT NOT NULL,
    codigo_turista INT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

-- Transportadoras_Historial
CREATE TABLE Transportadoras_Historial (
    id_version_transportadora INT IDENTITY(1,1) PRIMARY KEY,
    id_transportadora INT NOT NULL,
    nombre NVARCHAR(20) NOT NULL,
    telefono NVARCHAR(10) NOT NULL,
    nit NVARCHAR(10) NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

-- PagosReservas_Historial
CREATE TABLE PagosReservas_Historial (
    id_version_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_pago INT NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago NVARCHAR(20) NOT NULL,
    monto_total DECIMAL(18,2) NOT NULL,
    id_estado_pago INT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

-- Grupos_Historial
CREATE TABLE Grupos_Historial (
    id_version_grupo INT IDENTITY(1,1) PRIMARY KEY,
    id_grupo INT NOT NULL,
    id_guia INT NOT NULL,
    nombre NVARCHAR(60) NOT NULL,
    hora_salida TIME(7) NOT NULL,
    capacidad_maxima INT NOT NULL,
    id_estado_grupo INT NOT NULL,
    fecha_estado_actual DATE NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

-- Reservas_Historial
CREATE TABLE Reservas_Historial (
    id_version_reserva INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva INT NOT NULL,
    numero_personas INT NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL,
    fecha_estado_actual DATE NOT NULL,
    id_estado_reserva INT NOT NULL,
    id_tour INT NOT NULL,
    id_persona INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);




-- Precios_Historial
CREATE TABLE Precios_Historial (
    id_version_precio INT IDENTITY(1,1) PRIMARY KEY,
    id_precio INT NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    moneda NVARCHAR(MAX) NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    creada_por VARCHAR(50) NOT NULL,
    fecha_modificacion DATETIME,
    modificada_por VARCHAR(50),
    fecha_registro_historial DATETIME NOT NULL DEFAULT GETDATE(),
    versionada_por VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);





/* ============================================================
   TRIGGERS DE HISTORIAL (UPDATE/DELETE → insertar en tabla sombra)
   ============================================================ */

-- Personas
CREATE TRIGGER trg_Personas_Historial
ON Personas
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Personas_Historial (
        id_persona, nombre, apellido, direccion, telefono, documento_identidad,
        fecha_nacimiento, email, id_tipo_persona,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_persona, d.nombre, d.apellido, d.direccion, d.telefono, d.documento_identidad,
           d.fecha_nacimiento, d.email, d.id_tipo_persona,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

-- Guias
CREATE TRIGGER trg_Guias_Historial
ON Guias
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Guias_Historial (
        id_guia, id_persona, descripcion_guia, foto_perfil,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_guia, d.id_persona, d.descripcion_guia, d.foto_perfil,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

-- Tours
CREATE TRIGGER trg_Tours_Historial
ON Tours
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Tours_Historial (
        id_tour, nombre_comercial, descripcion, fecha_estado_actual,
         id_categoria_tour, id_estado, id_guia, capacidad_maxima,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_tour, d.nombre_comercial, d.descripcion, d.fecha_estado_actual,
            d.id_categoria_tour, d.id_estado, d.id_guia, d.capacidad_maxima,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

-- Turistas
CREATE TRIGGER trg_Turistas_Historial
ON Turistas
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Turistas_Historial (
        id_persona, id_ciudad_nacimiento, codigo_turista,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_persona, d.id_ciudad_nacimiento, d.codigo_turista,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

-- Transportadoras
CREATE TRIGGER trg_Transportadoras_Historial
ON Transportadoras
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Transportadoras_Historial (
        id_transportadora, nombre, telefono, nit,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_transportadora, d.nombre, d.telefono, d.nit,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

-- PagosReservas
CREATE TRIGGER trg_PagosReservas_Historial
ON PagosReservas
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO PagosReservas_Historial (
        id_pago, fecha_pago, metodo_pago, monto_total, id_estado_pago,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_pago, d.fecha_pago, d.metodo_pago, d.monto_total, d.id_estado_pago,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO


-- Grupos
CREATE TRIGGER trg_Grupos_Historial
ON Grupos
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Grupos_Historial (
        id_grupo, id_guia, nombre, hora_salida, capacidad_maxima,
        id_estado_grupo, fecha_estado_actual,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_grupo, d.id_guia, d.nombre, d.hora_salida, d.capacidad_maxima,
           d.id_estado_grupo, d.fecha_estado_actual,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO


-- Reservas
CREATE TRIGGER trg_Reservas_Historial
ON Reservas
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Reservas_Historial (
        id_reserva, numero_personas, monto_total, fecha_estado_actual,
        id_estado_reserva, id_tour, id_persona, id_grupo,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_reserva, d.numero_personas, d.monto_total, d.fecha_estado_actual,
           d.id_estado_reserva, d.id_tour, d.id_persona, d.id_grupo,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

-- Precios
CREATE TRIGGER trg_Precios_Historial
ON Precios
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO Precios_Historial (
        id_precio, precio, moneda,
        fecha_creacion, creada_por, fecha_modificacion, modificada_por,
        fecha_registro_historial, versionada_por
    )
    SELECT d.id_precio, d.precio, d.moneda,
           d.fecha_creacion, d.creada_por, d.fecha_modificacion, d.modificada_por,
           GETDATE(), SYSTEM_USER
    FROM deleted d;
END;
GO

/* ============================================================
   TRIGGERS DE TRAZABILIDAD (UPDATE → fecha_modificacion, modificada_por)
   ============================================================ */

-- Personas
CREATE TRIGGER trg_Personas_Update
ON Personas
AFTER UPDATE
AS
BEGIN
    UPDATE p
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Personas p
    INNER JOIN inserted i ON p.id_persona = i.id_persona;
END;
GO

-- Guias
CREATE TRIGGER trg_Guias_Update
ON Guias
AFTER UPDATE
AS
BEGIN
    UPDATE g
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Guias g
    INNER JOIN inserted i ON g.id_persona = i.id_persona;
END;
GO

-- Tours
CREATE TRIGGER trg_Tours_Update
ON Tours
AFTER UPDATE
AS
BEGIN
    UPDATE t
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Tours t
    INNER JOIN inserted i ON t.id_tour = i.id_tour;
END;
GO

-- Turistas
CREATE TRIGGER trg_Turistas_Update
ON Turistas
AFTER UPDATE
AS
BEGIN
    UPDATE tu
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Turistas tu
    INNER JOIN inserted i ON tu.id_persona = i.id_persona;
END;
GO

-- Transportadoras
CREATE TRIGGER trg_Transportadoras_Update
ON Transportadoras
AFTER UPDATE
AS
BEGIN
    UPDATE tr
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Transportadoras tr
    INNER JOIN inserted i ON tr.id_transportadora = i.id_transportadora;
END;
GO

-- PagosReservas
CREATE TRIGGER trg_PagosReservas_Update
ON PagosReservas
AFTER UPDATE
AS
BEGIN
    UPDATE pr
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM PagosReservas pr
    INNER JOIN inserted i ON pr.id_pago = i.id_pago;
END;
GO

-- Grupos
CREATE TRIGGER trg_Grupos_Update
ON Grupos
AFTER UPDATE
AS
BEGIN
    UPDATE g
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Grupos g
    INNER JOIN inserted i ON g.id_grupo = i.id_grupo;
END;
GO

-- Reservas
CREATE TRIGGER trg_Reservas_Update
ON Reservas
AFTER UPDATE
AS
BEGIN
    UPDATE r
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Reservas r
    INNER JOIN inserted i ON r.id_reserva = i.id_reserva;
END;
GO

-- Precios
CREATE TRIGGER trg_Precios_Update
ON Precios
AFTER UPDATE
AS
BEGIN
    UPDATE p
    SET fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Precios p
    INNER JOIN inserted i ON p.id_precio = i.id_precio;
END;
GO

--
CREATE TRIGGER trg_Tours_Inactivo_CancelarReservas
ON Tours
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i inner join Estados_tours et on i.id_estado = et.id_estado where et.nombre_estado = 'INACTIVO')
    BEGIN
        UPDATE r
        SET id_estado_reserva = (SELECT id_estado_reserva FROM EstadosReservas WHERE nombre_estado = 'CANCELADA'),
            fecha_modificacion = GETDATE(),
            modificada_por = SYSTEM_USER
        FROM Reservas r
        INNER JOIN inserted i ON r.id_tour = i.id_tour;

        -- Registrar en historial
        INSERT INTO Reservas_Historial (
            id_reserva, numero_personas, monto_total, fecha_estado_actual,
            id_estado_reserva, id_tour, id_persona, id_grupo,
            fecha_creacion, creada_por, fecha_modificacion, modificada_por,
            fecha_registro_historial, versionada_por
        )
        SELECT r.id_reserva, r.numero_personas, r.monto_total, r.fecha_estado_actual,
               r.id_estado_reserva, r.id_tour, r.id_persona, r.id_grupo,
               r.fecha_creacion, r.creada_por, r.fecha_modificacion, r.modificada_por,
               GETDATE(), SYSTEM_USER
        FROM Reservas r
        INNER JOIN inserted i ON r.id_tour = i.id_tour;
    END
END;
GO

CREATE TRIGGER trg_Grupos_Cerrar
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE g
    SET id_estado_grupo = (SELECT id_estado_grupo FROM EstadosGrupos WHERE nombre_estado = 'CERRADO'),
        fecha_modificacion = GETDATE(),
        modificada_por = SYSTEM_USER
    FROM Grupos g
    WHERE g.id_grupo IN (
        SELECT i.id_grupo
        FROM inserted i
        GROUP BY i.id_grupo
        HAVING COUNT(*) >= (SELECT capacidad_maxima FROM Grupos WHERE id_grupo = i.id_grupo)
    );
END;
GO

CREATE TRIGGER trg_Reservas_Disponibilidad
ON Reservas
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @id_grupo INT, @num_personas INT;
    SELECT @id_grupo = id_grupo, @num_personas = numero_personas FROM inserted;

    DECLARE @capacidad INT = (SELECT capacidad_maxima FROM Grupos WHERE id_grupo = @id_grupo);
    DECLARE @ocupados INT = (SELECT COUNT(*) FROM Reservas WHERE id_grupo = @id_grupo);

    IF (@ocupados + @num_personas) > @capacidad
    BEGIN
        RAISERROR('No se puede hacer la reserva: grupo sin disponibilidad.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Reservas (
            fecha_estado_actual, id_estado_reserva, numero_personas,
            id_tour, id_persona, id_grupo, monto_total,
            fecha_creacion, creada_por
        )
        SELECT fecha_estado_actual, id_estado_reserva, numero_personas,
               id_tour, id_persona, id_grupo, monto_total,
               GETDATE(), SYSTEM_USER
        FROM inserted;
    END
END;
GO

CREATE TRIGGER trg_Reservas_Monto
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE r
    SET monto_total = r.monto_total --  aquí puedes ajustar si quieres multiplicar por precio_tour
    FROM Reservas r
    INNER JOIN inserted i ON r.id_reserva = i.id_reserva;
END;
GO

CREATE TRIGGER trg_Reservas_Pagada
ON Pagos_Reserva_Reservas
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_reserva INT;
    SELECT @id_reserva = id_reserva FROM inserted;

    DECLARE @total_abonado DECIMAL(12,2) = (
        SELECT SUM(monto_consignado)
        FROM Pagos_Reserva_Reservas
        WHERE id_reserva = @id_reserva
    );

    DECLARE @precio DECIMAL(12,2) = (
        SELECT monto_total FROM Reservas WHERE id_reserva = @id_reserva
    );

    IF @total_abonado >= @precio
    BEGIN
        UPDATE r
        SET id_estado_reserva = (SELECT id_estado_reserva FROM EstadosReservas WHERE nombre_estado = 'PAGADA'),
            fecha_modificacion = GETDATE(),
            modificada_por = SYSTEM_USER
        FROM Reservas r
        WHERE r.id_reserva = @id_reserva;
    END
END;
GO


CREATE TRIGGER trg_Turistas_Validacion
ON Turistas
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @id_persona INT;

    SELECT @id_persona = id_persona FROM inserted;

    -- Verificar que la persona tenga tipo 'Turista'
    IF EXISTS (
        SELECT 1
        FROM Personas p
        INNER JOIN TiposPersonas tp ON p.id_tipo_persona = tp.id_tipo_persona
        WHERE p.id_persona = @id_persona
          AND UPPER(tp.nombre) = 'TURISTA'
    )
    BEGIN
        -- Si cumple, permitir la inserción
        INSERT INTO Turistas (id_ciudad_nacimiento, id_persona, codigo_turista, fecha_creacion, creada_por)
        SELECT id_ciudad_nacimiento, id_persona, codigo_turista, GETDATE(), SYSTEM_USER
        FROM inserted;
    END
    ELSE
    BEGIN
        RAISERROR('Solo se pueden insertar personas con tipo TURISTA en la tabla Turistas.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_Guias_Validacion
ON Guias
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @id_persona INT;

    SELECT @id_persona = id_persona FROM inserted;

    -- Verificar que la persona tenga tipo 'Guia'
    IF EXISTS (
        SELECT 1
        FROM Personas p
        INNER JOIN TiposPersonas tp ON p.id_tipo_persona = tp.id_tipo_persona
        WHERE p.id_persona = @id_persona
          AND UPPER(tp.nombre) = 'GUIA'
    )
    BEGIN
        -- Si cumple, permitir la inserción
        INSERT INTO Guias (id_guia, id_persona, descripcion_guia, foto_perfil, fecha_creacion, creada_por)
        SELECT id_guia, id_persona, descripcion_guia, foto_perfil, GETDATE(), SYSTEM_USER
        FROM inserted;
    END
    ELSE
    BEGIN
        RAISERROR('Solo se pueden insertar personas con tipo GUIA en la tabla Guias.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_TransportesAereos_Validacion
ON TransportesAereos
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar que el transporte insertado sea de tipo AEREO
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Transportes t ON i.id_transporte = t.id_transporte
        INNER JOIN TiposTransportes tt ON t.id_tipo_transporte = tt.id_tipo_transporte
        WHERE UPPER(tt.nombre) <> 'AEREO'
    )
    BEGIN
        RAISERROR('Solo se pueden insertar transportes de tipo AEREO en TransportesAereos.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Si cumple, permitir la inserción
    INSERT INTO TransportesAereos (id_transporte, matricula_aerea)
    SELECT id_transporte, matricula_aerea
    FROM inserted;
END;
GO

CREATE TRIGGER trg_TransportesTerrestres_Validacion
ON TransportesTerrestres
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Transportes t ON i.id_transporte = t.id_transporte
        INNER JOIN TiposTransportes tt ON t.id_tipo_transporte = tt.id_tipo_transporte
        WHERE UPPER(tt.nombre) <> 'TERRESTRE'
    )
    BEGIN
        RAISERROR('Solo se pueden insertar transportes de tipo TERRESTRE en TransportesTerrestres.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
    SELECT id_transporte, numero_placa
    FROM inserted;
END;
GO

CREATE TRIGGER trg_TransportesTerrestres_Validacion
ON TransportesTerrestres
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Transportes t ON i.id_transporte = t.id_transporte
        INNER JOIN TiposTransportes tt ON t.id_tipo_transporte = tt.id_tipo_transporte
        WHERE UPPER(tt.nombre) <> 'TERRESTRE'
    )
    BEGIN
        RAISERROR('Solo se pueden insertar transportes de tipo TERRESTRE en TransportesTerrestres.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    INSERT INTO TransportesTerrestres (id_transporte, numero_placa)
    SELECT id_transporte, numero_placa
    FROM inserted;
END;
GO

CREATE TRIGGER trg_Pagos_Reserva_Validacion
ON Pagos_Reserva_Reservas
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    -- Verificar si algún pago excede el monto_total de la reserva
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Reservas r ON i.id_reserva = r.id_reserva
        WHERE i.monto_consignado > r.monto_total
    )
    BEGIN
        RAISERROR('No se permiten pagos o abonos mayores al precio total de la reserva.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Si todo es válido, permitir la operación
    INSERT INTO Pagos_Reserva_Reservas (id_pago, id_reserva, monto_consignado)
    SELECT id_pago, id_reserva, monto_consignado
    FROM inserted;
END;
GO
