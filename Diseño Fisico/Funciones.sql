CREATE FUNCTION fn_FormatoTitulo (@titulo NVARCHAR(200))
RETURNS NVARCHAR(200)
AS
BEGIN
    RETURN CONCAT(UPPER(LEFT(LTRIM(RTRIM(@titulo)), 1)),
                  LOWER(SUBSTRING(LTRIM(RTRIM(@titulo)), 2, LEN(@titulo))));
END;

CREATE FUNCTION fn_EstadisticasTours()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        t.id_tour,

        -- uso de función escalar con sentido real
        dbo.fn_FormatoTitulo(t.nombre_comercial) AS titulo_formateado,

        -- agregaciones
        COUNT(r.id_resena) AS total_resenas,
        AVG(CAST(r.calificacion AS DECIMAL(5,2))) AS promedio_calificacion,

        -- subconsulta para obtener el precio actual (última vigencia)
        (
            SELECT TOP 1 p.precio
            FROM PreciosTours pt
            INNER JOIN Precios p 
                ON p.id_precio = pt.id_precio
            WHERE pt.id_tour = t.id_tour
            ORDER BY pt.fecha_inicio_vigencia DESC
        ) AS precio_actual

    FROM Tours t
    LEFT JOIN Resenas r 
        ON r.id_tour = t.id_tour
    GROUP BY 
        t.id_tour,
        t.nombre_comercial
);

CREATE FUNCTION fn_EtiquetaPopularidad (@totalTuristas INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    IF @totalTuristas >= 100 RETURN 'MUY POPULAR';
    IF @totalTuristas >= 40  RETURN 'POPULAR';
    IF @totalTuristas >= 10  RETURN 'NORMAL';
    RETURN 'POCO DEMANDADO';
END;

CREATE FUNCTION fn_ToursMasVendidos ()
RETURNS TABLE
AS
RETURN (

    SELECT 
        t.id_tour,
        t.nombre_comercial,

        -- TOTAL DE TURISTAS QUE HAN TOMADO EL TOUR
        COUNT(tg.id_turista) AS total_turistas,

        -- NÚMERO DE GRUPOS ACTIVOS (relación a EstadosGrupos)
        SUM(CASE 
                WHEN eg.nombre_estado = 'Activo' THEN 1 
                ELSE 0 
            END) AS grupos_activos,

        -- RECAUDACIÓN APROXIMADA (subconsulta al precio vigente)
        (
            COUNT(tg.id_turista) *
            (
                SELECT TOP 1 p.precio
                FROM PreciosTours pt
                INNER JOIN Precios p ON p.id_precio = pt.id_precio
                WHERE pt.id_tour = t.id_tour
                AND (
                        pt.fecha_fin_vigencia IS NULL
                        OR pt.fecha_fin_vigencia >= GETDATE()
                    )
                ORDER BY pt.fecha_inicio_vigencia DESC
            )
        ) AS recaudacion_aproximada,

        -- FUNCIÓN ESCALAR PARA CATEGORIZAR POPULARIDAD
        dbo.fn_EtiquetaPopularidad(COUNT(tg.id_turista)) AS etiqueta_popularidad

    FROM Tours t
    LEFT JOIN Grupos g
        ON g.id_tour = t.id_tour

    LEFT JOIN EstadosGrupos eg
        ON eg.id_estado_grupo = g.id_estado_grupo

    LEFT JOIN TuristasGrupos tg
        ON tg.id_grupo = g.id_grupo

    GROUP BY 
        t.id_tour,
        t.nombre_comercial
);

CREATE FUNCTION fn_EstadisticasPorGuia ()
RETURNS TABLE
AS
RETURN
(
    SELECT
        g.id_guia,
        p.nombre AS nombre_guia,

        -- Número de grupos que dirige el guía
        COUNT(DISTINCT gr.id_grupo) AS total_grupos,

        -- Número total de turistas en los grupos del guía
        COUNT(DISTINCT tg.id_turista) AS total_turistas,

        -- Grupo más popular del guía (por cantidad de turistas)
        (
            SELECT TOP 1 gr2.nombre
            FROM TuristasGrupos tg2
            INNER JOIN Grupos gr2 ON tg2.id_grupo = gr2.id_grupo
            WHERE gr2.id_guia = g.id_guia
            GROUP BY gr2.nombre
            ORDER BY COUNT(*) DESC
        ) AS grupo_mas_popular

    FROM Guias g
    INNER JOIN Personas p ON g.id_persona = p.id_persona
    LEFT JOIN Grupos gr ON gr.id_guia = g.id_guia
    LEFT JOIN TuristasGrupos tg ON tg.id_grupo = gr.id_grupo
    GROUP BY g.id_guia, p.nombre
);

CREATE FUNCTION fn_PromedioPreciosPorTour ()
RETURNS TABLE
AS
RETURN (

    SELECT
        t.id_tour,
        t.nombre_comercial,

        -- Precio máximo registrado
        MAX(p.precio) AS precio_maximo,

        -- Precio mínimo registrado
        MIN(p.precio) AS precio_minimo,

        -- Precio promedio registrado
        AVG(CAST(p.precio AS DECIMAL(10,2))) AS precio_promedio,

        -- Precio actual (subconsulta)
        (
            SELECT TOP 1 p2.precio
            FROM PreciosTours pt2
            INNER JOIN Precios p2 ON p2.id_precio = pt2.id_precio
            WHERE pt2.id_tour = t.id_tour
            AND (
                pt2.fecha_fin_vigencia IS NULL
                OR pt2.fecha_fin_vigencia >= GETDATE()
            )
            ORDER BY pt2.fecha_inicio_vigencia DESC
        ) AS precio_actual,

        -- Diferencia entre precio actual y el promedio
        (
            (
                SELECT TOP 1 p2.precio
                FROM PreciosTours pt2
                INNER JOIN Precios p2 
                    ON p2.id_precio = pt2.id_precio
                WHERE pt2.id_tour = t.id_tour
                AND (
                    pt2.fecha_fin_vigencia IS NULL
                    OR pt2.fecha_fin_vigencia >= GETDATE()
                )
                ORDER BY pt2.fecha_inicio_vigencia DESC
            )
            -
            AVG(CAST(p.precio AS DECIMAL(10,2)))
        ) AS diferencia_precio_actual_promedio

    FROM Tours t
    INNER JOIN PreciosTours pt ON pt.id_tour = t.id_tour
    INNER JOIN Precios p ON p.id_precio = pt.id_precio
    GROUP BY
        t.id_tour,
        t.nombre_comercial
);

CREATE FUNCTION fn_TransportesDisponibilidad()
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.id_transporte,
        t.descripcion AS nombre_transporte,

        -- Estado actual del transporte
        et.nombre_estado AS estado_transporte,

        -- Total de veces que este transporte aparece en logísticas
        COUNT(lt.id_logistica) AS usos_historicos,

        -- Número de logísticas diferentes en las que se ha usado
        COUNT(DISTINCT lt.id_logistica) AS logisticas_asociadas,

        -- Última logística donde se utilizó este transporte
        (
            SELECT TOP 1 lt2.id_logistica
            FROM LogisticaTransporte lt2
            WHERE lt2.id_transporte = t.id_transporte
            ORDER BY lt2.id_logistica DESC
        ) AS ultima_logistica_uso

    FROM Transportes t
    LEFT JOIN EstadosTransporteTransportes ett 
        ON ett.id_transporte = t.id_transporte
    LEFT JOIN EstadosTransportes et 
        ON et.id_estado_transporte = ett.id_estado_transporte

    LEFT JOIN LogisticaTransporte lt 
        ON lt.id_transporte = t.id_transporte

    GROUP BY
        t.id_transporte,
        t.descripcion,
        et.nombre_estado
);


CREATE FUNCTION fn_TourMultimediaResumen ()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        t.id_tour,
        t.nombre_comercial,
        
        -- Funciones de agregación
        COUNT(tm.id_multimedia) AS cantidad_videos,
        MAX(LEN(tm.archivo_video)) AS longitud_maxima_archivo,
        MIN(LEN(tm.archivo_video)) AS longitud_minima_archivo,

        -- Último archivo en orden alfabético
        MAX(tm.archivo_video) AS ultimo_archivo_alfabetico,

        -- Funciones escalares
        UPPER(t.nombre_comercial) AS nombre_mayuscula,
        LOWER(tm.archivo_video) AS archivo_minuscula,
        CONVERT(VARCHAR(10), t.fecha_estado_actual, 120) AS fecha_estado_texto,

        -- Ejemplo adicional: extensión del archivo (función escalar SUBSTRING)
        RIGHT(tm.archivo_video, CHARINDEX('.', REVERSE(tm.archivo_video)) - 1) AS extension_archivo,

        -- Combinación de tablas
        m.descripcion AS descripcion_multimedia,
        m.limite_tamanio AS peso_limite

    FROM Tours t
    INNER JOIN Tours_Multimedias tm
        ON t.id_tour = tm.id_multimedia   -- <- Tu tabla hace referencia cruzada
    INNER JOIN Multimedias m
        ON m.id_multimedia = tm.id_multimedia
    GROUP BY
        t.id_tour,
        t.nombre_comercial,
        tm.archivo_video,
        m.descripcion,
        m.limite_tamanio,
        t.fecha_estado_actual
);
GO

CREATE FUNCTION fn_CiudadResumen
(
    @id_ciudad INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.id_ciudad,
        c.nombre AS nombre_ciudad,
        
        -- Cantidad de tours relacionados mediante la tabla puente
        COUNT(DISTINCT tc.id_tour) AS cantidad_tours

    FROM Ciudades c
    LEFT JOIN ToursCiudades tc
        ON tc.id_ciudad = c.id_ciudad
    WHERE c.id_ciudad = @id_ciudad
    GROUP BY c.id_ciudad, c.nombre
);
GO

CREATE FUNCTION fn_DisponibilidadProximaTour
(
    @id_tour INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
        d.fecha_disponibilidad,
        d.hora_disponibilidad,
        dt.fecha_inicio_disponibilidad,
        dt.fecha_fin_disponibilidad
    FROM DisponibilidadesTours dt
    INNER JOIN Disponibilidades d
        ON d.id_disponibilidad = dt.id_disponibilidad
    WHERE dt.id_tour = @id_tour
          AND d.fecha_disponibilidad >= CAST(GETDATE() AS DATE)
    ORDER BY 
        d.fecha_disponibilidad ASC,
        d.hora_disponibilidad ASC
);
GO