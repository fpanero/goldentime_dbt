-- =============================================================================
-- stg_erp__tiendas · 1 fila = una tienda (13)
-- Staging: renombrar a nombres de negocio y poner tipos. 1:1 con Bronze:
-- no filtra, no deduplica, no une.
-- =============================================================================

with source as (

    select * from {{ source('erp', 'tiendas') }}

),

renamed as (

    select
          to_number(tienda_id)          as id_tienda
        , trim(nombre)                  as nombre_tienda
        , trim(ciudad)                  as ciudad
        , trim(pais)                    as pais
        , upper(trim(moneda))           as codigo_moneda
        , to_date(fecha_apertura)       as fecha_apertura
        , _fichero_origen               as fichero_origen
        , _loaded_at                    as loaded_at
    from source

)

select * from renamed
