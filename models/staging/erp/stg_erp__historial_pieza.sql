-- =============================================================================
-- stg_erp__historial_pieza · 1 fila = un evento de un reloj (564.209)
-- Staging: renombrar y poner tipos. 1:1 en filas con Bronze.
-- Dos tipos de evento en la misma tabla: TALLER (intervenciones) y
-- CAMBIO_PRECIO. Silver los separa en dos tablas.
-- Aquí los formatos llegan limpios (fechas ISO, importes con punto decimal):
-- basta con un cambio de tipo directo.
-- =============================================================================

with source as (

    select * from {{ source('erp', 'historial_pieza') }}

),

renamed as (

    select
          to_number(evento_id)                          as id_evento
        , to_number(pieza_id)                           as id_reloj_fisico
        , upper(trim(tipo_evento))                      as tipo_evento        -- TALLER | CAMBIO_PRECIO
        , to_date(fecha)                                as fecha_evento       -- taller: entrada
        , to_date(fecha_fin)                            as fecha_fin          -- taller: salida
        , trim(detalle)                                 as detalle            -- tipo de intervención o de cambio
        , trim(lugar_taller)                            as lugar_taller
        , try_to_decimal(coste_eur, 12, 2)              as coste_eur
        , try_to_decimal(precio_anterior, 12, 2)        as precio_anterior
        , try_to_decimal(precio_nuevo, 12, 2)           as precio_nuevo
        , upper(trim(moneda))                           as codigo_moneda
        , _fichero_origen                               as fichero_origen
        , _loaded_at                                    as loaded_at
    from source

)

select * from renamed
