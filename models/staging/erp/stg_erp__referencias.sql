-- =============================================================================
-- stg_erp__referencias · 1 fila = una referencia del catálogo (1.569)
-- Staging: 1:1 con Bronze en filas Y columnas (las 9). Los 69 duplicados
-- escritos de otra forma se quedan aquí; se resuelven en Silver.
-- =============================================================================

with source as (

    select * from {{ source('erp', 'referencias') }}

),

renamed as (

    select
          to_number(referencia_id)              as id_referencia
        , trim(marca)                           as nombre_marca
        , trim(modelo)                          as nombre_modelo
        , referencia                            as referencia_original   -- tal cual: se normaliza en Silver
        , trim(material_caja)                   as material_caja
        , trim(material_brazalete)              as material_brazalete
        , trim(movimiento)                      as movimiento
        , try_to_decimal(diametro_mm, 5, 1)     as diametro_mm
        , trim(genero)                          as genero
        , _fichero_origen                       as fichero_origen
        , _loaded_at                            as loaded_at
    from source

)

select * from renamed
