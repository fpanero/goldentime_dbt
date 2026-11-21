-- =============================================================================
-- slv_erp__cambio_precio · 1 fila = una rebaja o revalorización en vitrina (481.574)
-- Silver: las filas CAMBIO_PRECIO de historial_pieza.
--  Fuera: lugar_taller, fecha_fin y coste (vacías en los cambios de precio).
-- =============================================================================

with cambios as (

    select * from {{ ref('stg_erp__historial_pieza') }}
    where tipo_evento = 'CAMBIO_PRECIO'
      and precio_anterior <> precio_nuevo

),

monedas as (

    select valor_original, valor_limpio
    from {{ ref('diccionario_valores') }}
    where campo = 'moneda'

)

select
      c.id_evento                       as id_cambio_precio
    , c.id_reloj_fisico
    , c.detalle                         as tipo_cambio
    , c.fecha_evento                    as fecha_cambio
    , c.precio_anterior
    , c.precio_nuevo
    , m.valor_limpio                    as codigo_moneda
from cambios c
left join monedas m
    on upper(trim(c.codigo_moneda)) = m.valor_original
