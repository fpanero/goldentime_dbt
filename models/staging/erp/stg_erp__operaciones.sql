-- =============================================================================
-- stg_erp__operaciones · 1 fila = una compra o una venta (293.017)
-- Staging: 1:1 con Bronze en filas Y columnas (las 18). 
-- Tipos: las fechas (4 formatos), los importes (3 formatos) y los sí/no
-- (9 formas) se convierten con las macros de macros/limpieza/, porque se
-- repiten en varios modelos. 
-- =============================================================================

with source as (

    select * from {{ source('erp', 'operaciones') }}

),

renamed as (

    select
          to_number(operacion_id)                       as id_operacion
        , upper(trim(tipo_operacion))                   as tipo_operacion     -- COMPRA | VENTA
        , {{ texto_a_fecha('fecha') }}                  as fecha_operacion
        , to_number(tienda_id)                          as id_tienda
        , trim(empleado)                                as empleado_original
        , to_number(contacto_id)                        as id_contacto        -- compra: a quién compramos; venta: cliente
        , to_number(pieza_id)                           as id_reloj_fisico
        -- datos del reloj (solo en las filas COMPRA)
        , trim(numero_serie)                            as numero_serie
        , to_number(referencia_id)                      as id_referencia
        , try_to_number(anio_fabricacion)               as anio_fabricacion   -- 0, 19, 9999... se anulan en Silver
        , estado                                        as estado_original
        , {{ texto_a_booleano('tiene_caja') }}          as tiene_caja
        , {{ texto_a_booleano('tiene_papeles') }}       as tiene_papeles
        -- datos de la venta
        , canal                                         as canal_original
        , try_to_decimal(precio_lista, 12, 2)           as precio_lista
        , try_to_decimal(descuento_pct, 5, 1)           as descuento_pct
        -- importe de la operación, en su moneda
        , {{ texto_a_importe('importe') }}              as importe
        , moneda                                        as moneda_original
        , _fichero_origen                               as fichero_origen
        , _loaded_at                                    as loaded_at
    from source

)

select * from renamed
