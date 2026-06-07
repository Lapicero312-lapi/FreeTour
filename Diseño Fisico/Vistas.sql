CREATE VIEW vw_RankingToursCalificacion
AS
SELECT 
    t.id_tour,
    t.nombre_comercial,
    AVG(r.calificacion) AS calificacion_promedio,
    COUNT(r.id_resena) AS total_resenas,
    RANK() OVER (
        ORDER BY AVG(r.calificacion) DESC
    ) AS ranking
FROM Tours t
LEFT JOIN Resenas r
    ON r.id_tour = t.id_tour
GROUP BY 
    t.id_tour,
    t.nombre_comercial;
GO

CREATE VIEW v_CiudadesPorCantidadTours
AS
SELECT 
    c.id_ciudad,
    c.nombre AS ciudad,
    COUNT(tc.id_tour) AS cantidad_tours,

    -- Ranking de las ciudades con más tours
    RANK() OVER (ORDER BY COUNT(tc.id_tour) DESC) AS ranking_tours

FROM Ciudades c
LEFT JOIN ToursCiudades tc
    ON tc.id_ciudad = c.id_ciudad
GROUP BY 
    c.id_ciudad,
    c.nombre;
GO

CREATE VIEW vw_ToursRankingMultimedia
AS
SELECT 
    t.id_tour,
    t.nombre_comercial AS nombre_tour,
    COUNT(m.id_multimedia) AS total_multimedia,

    RANK() OVER (ORDER BY COUNT(m.id_multimedia) DESC) AS ranking_multimedia

FROM Tours t
LEFT JOIN Multimedias_tour_Tours mtt
    ON mtt.id_tour = t.id_tour
LEFT JOIN Tours_Multimedias tm
    ON tm.id_multimedia = mtt.id_tour_multimedia
LEFT JOIN Multimedias m
    ON m.id_multimedia = tm.id_multimedia
GROUP BY 
    t.id_tour,
    t.nombre_comercial;
GO

CREATE VIEW vw_PreciosHistoricosPorTour
AS
SELECT
    t.id_tour,
    t.nombre_comercial,
    p.id_precio,
    p.precio,
    p.moneda,
    pt.fecha_inicio_vigencia,
    pt.fecha_fin_vigencia
FROM Tours t
INNER JOIN PreciosTours pt 
    ON pt.id_tour = t.id_tour
INNER JOIN Precios p 
    ON p.id_precio = pt.id_precio;
GO


CREATE VIEW vw_CiudadesToursTuristas AS
SELECT 
    c.id_ciudad,
    c.nombre AS ciudad,
    COUNT(DISTINCT tc.id_tour) AS total_tours,
    COUNT(DISTINCT tu.id_persona) AS total_turistas
FROM Ciudades c
LEFT JOIN ToursCiudades tc
    ON tc.id_ciudad = c.id_ciudad
LEFT JOIN Turistas tu
    ON tu.id_ciudad_nacimiento = c.id_ciudad
GROUP BY c.id_ciudad, c.nombre;
GO


CREATE VIEW vw_ToursIngresos
AS
SELECT 
    t.id_tour,
    t.nombre_comercial,
    SUM(r.monto_total) AS ingreso_total,
    RANK() OVER (ORDER BY SUM(r.monto_total) DESC) AS ranking_ingreso
FROM Tours t
LEFT JOIN Reservas r ON t.id_tour = r.id_tour
GROUP BY t.id_tour, t.nombre_comercial;
GO

CREATE VIEW vw_Tours_PreciosVigentes
AS
SELECT 
    t.id_tour,
    t.nombre_comercial,
    ct.nombre AS categoria_tour,
    p.precio,
    p.moneda,
    pt.fecha_inicio_vigencia,
    pt.fecha_fin_vigencia,
    RANK() OVER (PARTITION BY t.id_tour ORDER BY pt.fecha_inicio_vigencia DESC) AS ranking_precio_vigente
FROM Tours t
JOIN CategoriasTours ct ON t.id_categoria_tour = ct.id_categoria_tour
LEFT JOIN PreciosTours pt ON t.id_tour = pt.id_tour
LEFT JOIN Precios p ON pt.id_precio = p.id_precio
WHERE pt.fecha_inicio_vigencia <= GETDATE()
AND (pt.fecha_fin_vigencia IS NULL OR pt.fecha_fin_vigencia >= GETDATE());
GO

CREATE VIEW vw_ToursDisponibilidad AS
SELECT 
    t.id_tour,
    t.nombre_comercial,
    COUNT(d.id_disponibilidad) AS total_disponibilidades,
    MIN(d.fecha_disponibilidad) AS primera_fecha_disponible,
    MAX(d.fecha_disponibilidad) AS ultima_fecha_disponible
FROM Tours t
LEFT JOIN DisponibilidadesTours dt
    ON dt.id_tour = t.id_tour
LEFT JOIN Disponibilidades d
    ON d.id_disponibilidad = dt.id_disponibilidad
GROUP BY t.id_tour, t.nombre_comercial;
GO

CREATE VIEW vw_TelefonosPersonasTransportadoras AS
SELECT 
    id_persona AS id_origen,
    'Persona' AS tipo_origen,
    telefono
FROM Personas

UNION ALL

SELECT
    id_transportadora AS id_origen,
    'Transportadora' AS tipo_origen,
    telefono
FROM Transportadoras;
GO


CREATE VIEW vw_RankingGuiasIngresos AS
SELECT 
    g.id_guia,
    p.nombre AS nombre_guia,
    COUNT(DISTINCT r.id_reserva) AS total_reservas,
    SUM(r.monto_total) AS ingresos_totales,
    RANK() OVER (ORDER BY SUM(r.monto_total) DESC) AS ranking_guia
FROM Guias g
INNER JOIN Personas p ON p.id_persona = g.id_persona
INNER JOIN Tours t ON t.id_guia = g.id_guia
INNER JOIN Reservas r ON r.id_tour = t.id_tour
GROUP BY g.id_guia, p.nombre;
GO

CREATE VIEW VW_Resenas_Consolidadas AS
SELECT
    R.id_resena,
    R.fecha AS FechaResena,
    R.calificacion AS Calificacion,
    R.texto AS Comentario,
    T.nombre_comercial AS Tour,
    P.nombre AS NombreTurista,
    P.email AS EmailTurista,
    P.documento_identidad AS DocumentoTurista
FROM
    Resenas R
JOIN
    Tours T ON R.id_tour = T.id_tour
JOIN
    Personas P ON R.id_persona = P.id_persona;
GO


CREATE VIEW VW_Reservas_Confirmadas AS
SELECT
    R.id_reserva,
    R.fecha_creacion AS FechaReserva,
    R.numero_personas,
    R.monto_total,
    ER.nombre_estado AS EstadoReserva,
    T.nombre_comercial AS NombreTour,
    P.nombre AS NombreTurista,
    P.email AS EmailTurista
FROM
    Reservas R
JOIN
    EstadosReservas ER ON R.id_estado_reserva = ER.id_estado_reserva
JOIN
    Tours T ON R.id_tour = T.id_tour
JOIN
    Turistas Tur ON R.id_persona = Tur.id_persona
JOIN
    Personas P ON Tur.id_persona = P.id_persona
WHERE
    ER.nombre_estado = 'CONFIRMADA';
GO

CREATE VIEW VW_Pagos_Metodo_Estadisticas AS
SELECT
    PR.metodo_pago,
    EP.nombre_estado AS EstadoPago,
    COUNT(PR.id_pago) AS NumeroTransacciones,
    SUM(PR.monto_total) AS MontoTotalDeclarado,
    SUM(PRR.monto_consignado) AS MontoTotalConsignado
FROM
    PagosReservas PR
JOIN
    EstadosPagos EP ON PR.id_estado_pago = EP.id_estado_pago
LEFT JOIN
    Pagos_Reserva_Reservas PRR ON PR.id_pago = PRR.id_pago
GROUP BY
    PR.metodo_pago,
    EP.nombre_estado
HAVING
    COUNT(PR.id_pago) > 0;
GO

CREATE VIEW VW_Transportadoras_Con_Estado AS
SELECT
    TR.id_transportadora,
    TR.nombre AS NombreTransportadora,
    TR.telefono,
    TR.nit,
    EST.nombre_estado AS EstadoActual
FROM
    Transportadoras TR
JOIN
    EstadosTransportadoraTransportadoras ETT ON TR.id_transportadora = ETT.id_transportadora
JOIN
    EstadosTransportadoras EST ON ETT.id_estado_transportadora = EST.id_estado_transportadora
WHERE
    ETT.fecha_establecimiento_estado = (
        SELECT MAX(fecha_establecimiento_estado)
        FROM EstadosTransportadoraTransportadoras ETT2
        WHERE ETT2.id_transportadora = TR.id_transportadora
    );
GO

CREATE VIEW VW_Reservas_Detalles_Pago_Monto AS
SELECT
    R.id_reserva,
    P.nombre AS Turista,
    T.nombre_comercial AS Tour,
    ER.nombre_estado AS EstadoReserva,
    R.monto_total AS MontoTotalReserva,
    COALESCE(SUM(PRR.monto_consignado), 0) AS MontoTotalConsignado,
    R.monto_total - COALESCE(SUM(PRR.monto_consignado), 0) AS MontoPendiente,
    CASE
        WHEN R.monto_total - COALESCE(SUM(PRR.monto_consignado), 0) <= 0 THEN 'PAGADO COMPLETAMENTE'
        ELSE 'PENDIENTE DE PAGO'
    END AS EstadoFinanciero
FROM
    Reservas R
JOIN
    Personas P ON R.id_persona = P.id_persona
JOIN
    Tours T ON R.id_tour = T.id_tour
JOIN
    EstadosReservas ER ON R.id_estado_reserva = ER.id_estado_reserva
LEFT JOIN
    Pagos_Reserva_Reservas PRR ON R.id_reserva = PRR.id_reserva
GROUP BY
    R.id_reserva, P.nombre, T.nombre_comercial, ER.nombre_estado, R.monto_total;
GO

CREATE VIEW VW_Resumen_Categorias_Activas AS
SELECT
    CT.id_categoria_tour,
    CT.nombre AS NombreCategoria,
    CT.descripcion AS DescripcionCategoria,
    EC.nombre_estado AS EstadoCategoria
FROM
    CategoriasTours CT
JOIN
    EstadosCategorias EC ON CT.id_estado_categoria = EC.id_estado_categoria
WHERE
    EC.nombre_estado = 'ACTIVO';
GO

CREATE VIEW VW_Resenas_Archivos_Detalles AS
SELECT
    R.id_resena,
    P.nombre AS NombreTurista,
    T.nombre_comercial AS TourResenado,
    R.calificacion,
    R.texto AS ComentarioResena,
    -- Información del Archivo Multimedia
    MR.archivo AS RutaArchivo,
    MR.formato AS FormatoArchivo,
    MR.tamanio_archivo AS TamanioArchivoBytes,
    MR.fecha_subida AS FechaSubidaArchivo
FROM
    Resenas R
JOIN
    Personas P ON R.id_persona = P.id_persona
JOIN
    Tours T ON R.id_tour = T.id_tour
-- Tabla asociativa que une la Reseña con los archivos
JOIN
    Multimedias_resena_Resenas MRR ON R.id_resena = MRR.id_resena
-- Tabla que contiene los metadatos del archivo
JOIN
    Multimedias_resenas MR ON MRR.id_resena_multimedia = MR.id_multimedia;
GO

CREATE VIEW VW_Guias_Idiomas_Detalles AS
SELECT
    P.id_persona AS ID_Guia,
    P.nombre AS NombreGuia,
    P.email AS EmailGuia,
    -- Lista consolidada de idiomas
    STUFF(
        (SELECT ', ' + I.nombre
         FROM GuiasIdiomas GI
         JOIN Idiomas I ON GI.id_idioma = I.id_idioma
         WHERE GI.id_persona = P.id_persona
         FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
    , 1, 2, '') AS IdiomasHablados
FROM
    Personas P
JOIN
    Guias G ON P.id_persona = G.id_persona;
GO

CREATE VIEW VW_Guias_Sin_Aprobacion AS
SELECT
    P.id_persona AS ID_Guia,
    P.nombre AS NombreGuia,
    G.fecha_creacion AS FechaRegistroGuia
FROM
    Guias G
JOIN
    Personas P ON G.id_persona = P.id_persona
LEFT JOIN
    AprobacionesInternasGuias AIG ON G.id_persona = AIG.id_guia
WHERE
    AIG.id_guia IS NULL;
GO

CREATE VIEW VW_Sugerencias_Recientes_Por_Tour AS
SELECT
    S.id_sugerencia,
    T.nombre_comercial AS Tour,
    S.descripcion AS Sugerencia,
    S.fecha
FROM
    Sugerencias S
JOIN
    Tours T ON S.id_tour = T.id_tour
WHERE
    S.fecha >= DATEADD(month, -3, GETDATE()) -- Sugerencias de los últimos 3 meses
GO

CREATE VIEW VW_Disponibilidad_Transporte_Aereo_Operativo AS
SELECT
    TTA.matricula_aerea,
    TRA.nombre AS Transportadora,
    T.descripcion AS DescripcionAeronave,
    ET.nombre_estado AS EstadoOperativo
FROM
    Transportes T
JOIN
    TransportesAereos TTA ON T.id_transporte = TTA.id_transporte
JOIN
    Transportadoras TRA ON T.id_transportadora = TRA.id_transportadora
JOIN
    EstadosTransporteTransportes ETT ON T.id_transporte = ETT.id_transporte
JOIN
    EstadosTransportes ET ON ETT.id_estado_transporte = ET.id_estado_transporte
WHERE
    ET.nombre_estado = 'ACTIVO' -- Filtra solo los transportes activos
    AND ETT.fecha_establecimiento_estado = (
        SELECT MAX(ETT2.fecha_establecimiento_estado)
        FROM EstadosTransporteTransportes ETT2
        WHERE ETT2.id_transporte = T.id_transporte
    );
GO

CREATE VIEW VW_Guias_Con_Experiencia AS
    SELECT 
        G.id_guia,
        P.nombre + ' ' + P.apellido AS NombreGuia,
        COUNT(DISTINCT T.id_tour) AS TotalTours
    FROM Guias G
    JOIN Personas P ON G.id_persona = P.id_persona
    LEFT JOIN Tours T ON G.id_guia = T.id_guia
    GROUP BY G.id_guia, P.nombre, P.apellido;
GO

CREATE VIEW VW_LasReservas AS
SELECT 
    R.id_reserva,
    R.fecha_creacion AS FechaReserva,
    R.numero_personas,
    R.monto_total,
    ER.nombre_estado AS EstadoReserva,
    T.nombre_comercial AS NombreTour,
    P.nombre + ' ' + P.apellido AS NombreTurista,
    P.email AS EmailTurista
FROM Reservas R
JOIN EstadosReservas ER ON R.id_estado_reserva = ER.id_estado_reserva
JOIN Tours T ON R.id_tour = T.id_tour
JOIN Turistas Tu ON R.id_persona = Tu.id_persona
JOIN Personas P ON Tu.id_persona = P.id_persona;
GO

CREATE VIEW VW_Guias_MultiIdioma AS
SELECT 
    G.id_guia,
    P.nombre + ' ' + P.apellido AS NombreGuia,
    STRING_AGG(I.nombre, ', ') AS Idiomas,
    COUNT(DISTINCT I.id_idioma) AS TotalIdiomas
FROM Guias G
JOIN Personas P ON G.id_persona = P.id_persona
JOIN GuiasIdiomas GI ON G.id_persona = GI.id_persona
JOIN Idiomas I ON GI.id_idioma = I.id_idioma
GROUP BY G.id_guia, P.nombre, P.apellido
HAVING COUNT(DISTINCT I.id_idioma) > 1;
GO




