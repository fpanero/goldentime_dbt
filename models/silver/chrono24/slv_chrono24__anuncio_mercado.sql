-- =============================================================================
-- slv_chrono24__anuncio_mercado · 1 fila = un anuncio de Chrono24 (283.843)
-- =============================================================================

with anuncios as (

    select * from {{ ref('stg_chrono24__mercado_anuncios') }}

),

diccionario as (

    select * from {{ ref('diccionario_valores') }}

),

marcas as (

    select * from {{ ref('slv_erp__marca') }}

),

modelos as (

    select * from {{ ref('slv_erp__modelo_reloj') }}

),

unificados as (

    select
          coalesce(url_anuncio_a, url_anuncio_b)                                    as url_anuncio
        , trim(regexp_replace(coalesce(titulo_a, titulo_b), '\\s+', ' '))           as titulo
        , nullif(marca_anunciada, '')                                               as marca_anunciada
        , nullif(modelo_anunciado, '')                                              as modelo_anunciado
        , {{ normalizar_referencia("nullif(referencia_anunciada, '')") }}           as referencia_anunciada
        , upper(nullif(coalesce(estado_anuncio_a, estado_anuncio_b), ''))           as estado_original
        , upper(nullif(coalesce(genero_a, genero_b), ''))                           as genero_original
        , try_to_number(regexp_substr(anio_fabricacion_texto, '^[0-9]{4}'))         as anio_fabricacion
        , try_to_decimal(regexp_substr(tamano_texto, '[0-9]+(\\.[0-9]+)?'), 5, 1)   as diametro_mm
        , precio_usd
        , fichero_origen
        , orden_scraper
    from anuncios
    where nullif(marca_anunciada, '') is not null

),

deduplicados as (

    select *
    from unificados
    qualify row_number() over (
        partition by url_anuncio
        order by precio_usd is null, fichero_origen, orden_scraper
    ) = 1

)

select
      {{ dbt_utils.generate_surrogate_key(['a.url_anuncio']) }}   as id_anuncio
    , a.url_anuncio
    , mo.id_modelo_reloj
    , a.titulo
    , a.marca_anunciada
    , a.modelo_anunciado
    , a.referencia_anunciada
    , e.valor_limpio                                              as estado_anuncio
    , a.anio_fabricacion
    , g.valor_limpio                                              as genero
    , a.diametro_mm
    , a.precio_usd
    , a.fichero_origen
from deduplicados a
left join diccionario e
    on e.campo = 'estado' and a.estado_original = e.valor_original
left join diccionario g
    on g.campo = 'genero' and a.genero_original = g.valor_original
left join marcas ma
    on a.marca_anunciada = ma.nombre_marca
left join modelos mo
    on  mo.id_marca   = ma.id_marca
    and mo.referencia = a.referencia_anunciada
