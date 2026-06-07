-- Tabla tipo para recibir las multimedias
CREATE TYPE TipoMultimediaResena AS TABLE
(
    id_multimedia INT,
    archivo VARCHAR(255)
);
GO

CREATE PROCEDURE sp_InsertarResenaConMultimedia
(
    @id_tour INT,
    @id_persona INT,
    @fecha DATE,
    @texto VARCHAR(MAX),
    @calificacion INT,
    @Multimedias TipoMultimediaResena READONLY
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        ------------------------------
        -- 1. INSERTAR LA RESEÑA
        ------------------------------
        INSERT INTO Resena (id_tour, id_persona, fecha, texto, calificacion)
        VALUES (@id_tour, @id_persona, @fecha, @texto, @calificacion);

        DECLARE @id_resena INT = SCOPE_IDENTITY();


        ------------------------------
        -- 2. INSERTAR LAS MULTIMEDIAS
        ------------------------------
        INSERT INTO Multimedia_resena (id_multimedia, archivo)
        SELECT id_multimedia, archivo
        FROM @Multimedias;

        ------------------------------
        -- 3. RELACIONAR MULTIMEDIA–RESEÑA
        ------------------------------
        INSERT INTO Multimedia_resena_Resenas (id_resena_multimedia, id_resena)
        SELECT mr.id_resena_multimedia, @id_resena
        FROM Multimedia_resena mr
        WHERE mr.id_resena_multimedia IN (
            SELECT id_resena_multimedia
            FROM Multimedia_resena
            WHERE id_multimedia IN (SELECT id_multimedia FROM @Multimedias)
        );

        ------------------------------
        -- 4. DEVOLVER ID DE LA RESEÑA
        ------------------------------
        SELECT @id_resena AS id_resena_creada;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE sp_CrearPrecioTour
(
    @id_tour INT,
    @precio DECIMAL(9,6),
    @moneda VARCHAR(10),
    @fecha_inicio DATE,
    @fecha_fin DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_precio INT;

    -- 1. Insertar precio
    INSERT INTO Precios (precio, moneda)
    VALUES (@precio, @moneda);

    SET @id_precio = SCOPE_IDENTITY();

    -- 2. Relacionarlo con el tour
    INSERT INTO PreciosTours (id_tour, id_precio, fecha_inicio_vigencia, fecha_fin_vigencia)
    VALUES (@id_tour, @id_precio, @fecha_inicio, @fecha_fin);

    -- 3. Devolver el nuevo id
    SELECT @id_precio AS id_precio_creado;
END
GO

CREATE PROCEDURE sp_ObtenerPrecioVigenteTour
(
    @id_tour INT
)
AS
BEGIN
    SELECT TOP 1 
        p.id_precio,
        p.precio,
        p.moneda,
        pt.fecha_inicio_vigencia,
        pt.fecha_fin_vigencia
    FROM PreciosTours pt
    INNER JOIN Precios p ON p.id_precio = pt.id_precio
    WHERE pt.id_tour = @id_tour
      AND (pt.fecha_fin_vigencia IS NULL OR pt.fecha_fin_vigencia >= GETDATE())
      AND pt.fecha_inicio_vigencia <= GETDATE()
    ORDER BY pt.fecha_inicio_vigencia DESC;
END
GO

CREATE PROCEDURE sp_CrearGuiaYAsignarATour1
(
    -- Datos de Persona
    @nombre              VARCHAR(50),
    @apellido            VARCHAR(50),
    @direccion           VARCHAR(30),
    @telefono            VARCHAR(15),
    @documento_identidad VARCHAR(10),
    @fecha_nacimiento    DATE,
    @correo              VARCHAR(50),
    @id_tipo_persona     INT,

    -- Datos del Guía
    @descripcion_guia    VARCHAR(300),
    @foto_perfil         VARCHAR(100),

    -- Tour a asignar
    @id_tour             INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------
    -- 1. Insertar en Persona
    ------------------------------
    INSERT INTO Persona(
        nombre, apellido,direccion, telefono, documento_identidad,
        fecha_nacimiento, email, id_tipo_persona
    )
    VALUES(
        @nombre, @apellido,@direccion, @telefono, @documento_identidad,
        @fecha_nacimiento, @correo, @id_tipo_persona
    );

    DECLARE @id_persona INT = SCOPE_IDENTITY();

    ------------------------------
    -- 2. Insertar en Guía
    ------------------------------
    INSERT INTO Guia(
        id_persona,
        descripcion,
        foto_perfil
    )
    VALUES(
        @id_persona,
        @descripcion_guia,
        @foto_perfil
    );

    ------------------------------
    -- 3. Asignar guía al tour
    ------------------------------
    INSERT INTO GuiasTours(
        id_persona,
        id_tour
    )
    VALUES(
        @id_persona,
        @id_tour
    );

    ------------------------------
    -- 4. Devolver id creado
    ------------------------------
    SELECT 
        @id_persona AS id_persona,
        @id_tour AS id_tour_asignado;
END;
GO

CREATE PROCEDURE sp_CrearTransporteYAsignarLogistica
(
    @id_tipo_transporte INT,
    @id_transportadora INT,
    @descripcion VARCHAR(150),
    @id_logistica INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Crear transporte
    INSERT INTO Transporte (id_tipo_transporte, id_transportadora, descripcion)
    VALUES (@id_tipo_transporte, @id_transportadora, @descripcion);

    DECLARE @id_transporte INT = SCOPE_IDENTITY();

    -- 2. Asignar transporte a la logística
    INSERT INTO logisticasTransportes (id_tour_transporte, id_tour, id_transporte)
    SELECT 
        NULL,          -- se autogenera
        l.id_tour,     -- tomamos el tour desde Logistica
        @id_transporte 
    FROM Logistica l
    WHERE l.id_logistica = @id_logistica;

    -- Resultado
    SELECT @id_transporte AS id_transporte_creado;
END;
GO

CREATE PROCEDURE sp_CrearReserva
(
    @id_estado_reserva INT,
    @numero_personas INT,
    @id_tour INT,
    @id_grupo INT,
    @monto_total DECIMAL(9,6),
    @fecha_estado_actual DATE = NULL,
    @id_reserva_out INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_estado_actual IS NULL
        SET @fecha_estado_actual = CAST(GETDATE() AS DATE);

    INSERT INTO Reserva
    (
        id_estado_reserva,
        numero_personas,
        id_tour,
        id_grupo,
        monto_total,
        fecha_estado_actual
    )
    VALUES
    (
        @id_estado_reserva,
        @numero_personas,
        @id_tour,
        @id_grupo,
        @monto_total,
        @fecha_estado_actual
    );

    SET @id_reserva_out = SCOPE_IDENTITY();
END;
GO

CREATE PROCEDURE sp_GestionarPagoReserva
(
    @id_reserva        INT,
    @metodo_pago       VARCHAR(50),
    @monto_consignado  DECIMAL(12,2),
    @id_estado_pago    INT, -- Ej: pagado, pendiente, rechazado
    @id_pago_generado  INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que la reserva exista
    IF NOT EXISTS (SELECT 1 FROM Reserva WHERE id_reserva = @id_reserva)
    BEGIN
        RAISERROR('La reserva no existe.', 16, 1);
        RETURN;
    END;

    DECLARE @fecha_actual DATE = CAST(GETDATE() AS DATE);

    ---------------------------------------------
    -- 1. Insertar en Pago_Reserva
    ---------------------------------------------
    INSERT INTO Pago_Reserva (fecha_estado_actual, fecha_pago, metodo_pago, monto_total, id_estado_pago)
    VALUES (@fecha_actual, @fecha_actual, @metodo_pago, @monto_consignado, @id_estado_pago);

    SET @id_pago_generado = SCOPE_IDENTITY();

    ---------------------------------------------
    -- 2. Insertar en Pago_Reserva_Reservas (tabla intermedia)
    ---------------------------------------------
    INSERT INTO Pago_Reserva_Reservas (id_pago, id_reserva, monto_consignado)
    VALUES (@id_pago_generado, @id_reserva, @monto_consignado);

    ---------------------------------------------
    -- 3. Verificar si ya se completó el monto total de la reserva
    ---------------------------------------------
    DECLARE @total_pagado DECIMAL(9,6) =
        (SELECT SUM(monto_consignado)
         FROM Pago_Reserva_Reservas
         WHERE id_reserva = @id_reserva);

    DECLARE @monto_reserva DECIMAL(9,6) =
        (SELECT monto_total FROM Reserva WHERE id_reserva = @id_reserva);

    ---------------------------------------------
    -- 4. Si ya cubrió el monto total, cerrar el pago
    ---------------------------------------------
    IF @total_pagado >= @monto_reserva
    BEGIN
        -- Estado pagado = 2 (por ejemplo)
        UPDATE Pago_Reserva
        SET id_estado_pago = @id_estado_pago,
            fecha_estado_actual = @fecha_actual
        WHERE id_pago = @id_pago_generado;
    END

END;
GO

CREATE PROCEDURE sp_CancelarReserva
(
    @id_reserva INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Validar que la reserva exista
    IF NOT EXISTS (SELECT 1 FROM Reserva WHERE id_reserva = @id_reserva)
    BEGIN
        RAISERROR('La reserva no existe.', 16, 1);
        RETURN;
    END;

    -- 2. Cambiar estado de la reserva a "Cancelada" 
    -- (suponiendo que el estado cancelado es 3)
    UPDATE Reserva
    SET 
        id_estado_reserva = 3,
        fecha_estado_actual = GETDATE()
    WHERE id_reserva = @id_reserva;

    -- 3. También actualizar pagos asociados a estado "Anulado"
    -- (suponiendo que el estado anulado del pago es 4)
    UPDATE Pago_Reserva
    SET 
        id_estado_pago = 4,
        fecha_estado_actual = GETDATE()
    WHERE id_pago IN (
        SELECT id_pago FROM Pago_Reserva_Reservas
        WHERE id_reserva = @id_reserva
    );

    -- 4. Opcional: liberar cupos del grupo (si tu lógica lo requiere)
    DECLARE @id_grupo INT;

    SELECT @id_grupo = id_grupo
    FROM Reserva
    WHERE id_reserva = @id_reserva;

    IF @id_grupo IS NOT NULL
    BEGIN
        UPDATE Grupo
        SET capacidad_maxima = capacidad_maxima + (
            SELECT numero_personas FROM Reserva WHERE id_reserva = @id_reserva
        )
        WHERE id_grupo = @id_grupo;
    END

    SELECT 'Reserva cancelada correctamente' AS mensaje;
END;
GO

CREATE PROCEDURE sp_CrearTurista
(
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @direccion VARCHAR(30),
    @telefono VARCHAR(15),
    @documento_identidad VARCHAR(10),
    @fecha_nacimiento DATE,
    @email VARCHAR(50),
    @id_tipo_persona INT,
    @id_ciudad_nacimiento INT,
    @codigo_turista INT,
    @id_turista INT,
    @id_persona_creado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insertar Persona
        INSERT INTO Persona(
            nombre,
            apellido,
            direccion,
            telefono,
            documento_identidad,
            fecha_nacimiento,
            email,
            id_tipo_persona
        )
        VALUES (
            @nombre,
            @apellido,
            @direccion,
            @telefono,
            @documento_identidad,
            @fecha_nacimiento,
            @email,
            @id_tipo_persona
        );

        SET @id_persona_creado = SCOPE_IDENTITY();

        -- 2. Insertar Turista
        INSERT INTO Turista(
            id_persona,
            id_ciudad_nacimiento,
            id_turista,
            codigo_turista
        )
        VALUES (
            @id_persona_creado,
            @id_ciudad_nacimiento,
            @id_turista,
            @codigo_turista
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;

        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE sp_CrearGrupoCompleto
(
    @id_tour INT,
    @id_guia INT,
    @nombre_grupo VARCHAR(60),
    @hora_salida TIME,
    @capacidad_maxima INT,
    @id_transporte INT,
    @id_estado_inicial INT,
    @id_grupo_creado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        ------------------------------
        -- 1. Validar que el tour exista
        ------------------------------
        IF NOT EXISTS (SELECT 1 FROM Tours WHERE id_tour = @id_tour)
        BEGIN
            RAISERROR('El tour no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        ---------------------------------------
        -- 2. Validar que el guía exista
        ---------------------------------------
        IF NOT EXISTS (SELECT 1 FROM Guia WHERE id_persona = @id_guia)
        BEGIN
            RAISERROR('El guía no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        ---------------------------------------
        -- 3. Validar que el transporte exista
        ---------------------------------------
        IF NOT EXISTS (SELECT 1 FROM Transporte WHERE id_transporte = @id_transporte)
        BEGIN
            RAISERROR('El transporte no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        ---------------------------------------
        -- 4. Crear el grupo
        ---------------------------------------
        INSERT INTO Grupo
        (
            id_tour,
            nombre,
            hora_salida,
            capacidad_maxima,
            fecha_estado_actual,
            id_persona
        )
        VALUES
        (
            @id_tour,
            @nombre_grupo,
            @hora_salida,
            @capacidad_maxima,
            GETDATE(),
            @id_guia
        );

        SET @id_grupo_creado = SCOPE_IDENTITY();

        ---------------------------------------
        -- 5. Registrar estado inicial
        ---------------------------------------
        INSERT INTO EstadosGruposHistoricos
        (
            id_grupo,
            id_estado,
            fecha_finalizacion
        )
        VALUES
        (
            @id_grupo_creado,
            @id_estado_inicial,
            NULL
        );

        ---------------------------------------
        -- 6. Asignar transporte al grupo
        ---------------------------------------
        INSERT INTO logisticasTransportes
        (
            id_tour_transporte,
            id_tour,
            id_transporte
        )
        VALUES
        (
            @id_grupo_creado, -- lo usamos como identificador único
            @id_tour,
            @id_transporte
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @msg VARCHAR(400) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END
GO

CREATE PROCEDURE sp_ReporteReservasPorDestino
    @id_ciudad INT = NULL,      -- NULL = todas las ciudades
    @fecha_inicio DATE = NULL,  -- rango opcional
    @fecha_fin DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.nombre AS ciudad,
        t.id_tour,
        t.nombre_comercial AS tour,
        g.nombre AS guia,
        gr.nombre AS grupo,
        r.id_reserva,
        r.fecha_creacion,
        r.numero_personas,
        r.monto_total AS total_reserva,
        er.nombre_estado AS estado_reserva,
        SUM(prr.monto_consignado) AS total_pagado,

        -- métricas
        COUNT(r.id_reserva) OVER (PARTITION BY c.id_ciudad) AS total_reservas_ciudad,
        SUM(r.numero_personas) OVER (PARTITION BY c.id_ciudad) AS total_turistas_ciudad

    FROM Reserva r
    INNER JOIN Tours t 
        ON t.id_tour = r.id_tour
    INNER JOIN Ciudad c 
        ON c.id_ciudad = t.id_ciudad
    INNER JOIN Estado_Reserva er
        ON er.id_estado_reserva = r.id_estado_reserva
    LEFT JOIN Grupo gr
        ON gr.id_grupo = r.id_grupo
    LEFT JOIN Persona g
        ON g.id_persona = gr.id_persona   -- Guía asignado al grupo
    LEFT JOIN Pago_Reserva_Reservas prr
        ON prr.id_reserva = r.id_reserva

    WHERE 
        (@id_ciudad IS NULL OR c.id_ciudad = @id_ciudad)
        AND (@fecha_inicio IS NULL OR r.fecha_creacion >= @fecha_inicio)
        AND (@fecha_fin IS NULL OR r.fecha_creacion <= @fecha_fin)

    GROUP BY 
        c.nombre, c.id_ciudad,
        t.id_tour, t.nombre_comercial,
        g.nombre,
        gr.nombre,
        r.id_reserva, r.fecha_creacion, 
        r.numero_personas, r.monto_total,
        er.nombre_estado;
END;
GO