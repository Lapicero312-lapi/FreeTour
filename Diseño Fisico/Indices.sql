CREATE NONCLUSTERED INDEX rendimientoPersonas on Personas(apellido);
CREATE NONCLUSTERED INDEX rendimientoGrupos on Grupos(id_estado_grupo);
CREATE NONCLUSTERED INDEX rendimientoTours on Tours(capacidad_maxima,id_estado)
CREATE NONCLUSTERED INDEX rendimientoTurista on Turistas(id_ciudad_nacimiento)
CREATE NONCLUSTERED INDEX rendimientoReservas on Reservas(fecha_estado_actual)
CREATE NONCLUSTERED INDEX rendimientoResenas on Resenas(calificacion)
CREATE NONCLUSTERED INDEX rendimientoPrecios on Precios(precio,moneda)
CREATE NONCLUSTERED INDEX rendimientoLogisticas on Logisticas(duracion_estimado)