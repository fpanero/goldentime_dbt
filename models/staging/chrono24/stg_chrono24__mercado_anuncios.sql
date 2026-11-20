-- =============================================================================
-- stg_chrono24__mercado_anuncios · 1 fila = un anuncio de Chrono24 (julio 2023)
-- Staging: 1:1 con Bronze en filas Y columnas (las 26 del scraper).
-- Las columnas vienen de DOS formatos de fichero: cada fila rellena las de su
-- formato y deja NULL las del otro. Aquí solo se les da nombre en español;
-- juntar cada pareja (titulo_a / titulo_b → titulo...), quitar los anuncios
-- duplicados y extraer el diámetro de "42 mm" se hace en Silver.
-- Único cambio de tipo: el precio ("$19,995 " → 19995.00). "Price on request"
-- queda NULL. El año se guarda como texto: trae "Unknown" y "2013 (Approximation)".
-- =============================================================================

with source as (

    select * from {{ source('chrono24', 'mercado_anuncios') }}

),

renamed as (

    select
        -- comunes a los dos formatos
          web_scraper_order                         as orden_scraper
        , web_scraper_start_url                     as url_inicio_scraper
        , price                                     as precio_original
        , {{ texto_a_importe('price') }}            as precio_usd
        , trim(brand)                               as marca_anunciada
        , trim(model)                               as modelo_anunciado
        , trim(ref)                                 as referencia_anunciada
        , trim(casem)                               as material_caja
        , trim(bracem)                              as material_brazalete
        , trim(yop)                                 as anio_fabricacion_texto
        , trim(size)                                as tamano_texto
        -- formato A (rolex1, rolex2)
        , pagination                                as pagina_a
        , pagination_href                           as url_pagina_a
        , select_watch                              as tarjeta_a
        , select_watch_href                         as url_anuncio_a
        , trim(title)                               as titulo_a
        , trim(condition)                           as estado_anuncio_a
        , trim(movement)                            as movimiento_a
        , trim(gender)                              as genero_a
        -- formato B (los otros 16 ficheros)
        , select_brands                             as marca_listado_b
        , select_brands_href                        as url_marca_b
        , aaaaaaaaaaaaaaaaa                         as tarjeta_b
        , aaaaaaaaaaaaaaaaa_href                    as url_anuncio_b
        , trim(name)                                as titulo_b
        , trim(cond)                                as estado_anuncio_b
        , trim(mvmt)                                as movimiento_b
        , trim(sex)                                 as genero_b
        -- metadatos
        , _fichero_origen                           as fichero_origen
        , _loaded_at                                as loaded_at
    from source

)

select * from renamed
