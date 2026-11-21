-- =============================================================================
-- slv_erp__compra · 1 fila = una compra (150.000)
-- Silver: las filas COMPRA de operaciones, solo con lo que es de la compra
-- (los datos del reloj viven en slv_erp__reloj_fisico: 3FN).
--   - Moneda: 14 escrituras ("Euro", "€", "Fr.", "US$"...) → EUR, CHF, GBP,
--     USD, con el seed diccionario_valores.
--   - Empleado: misma clave que slv_erp__empleado (misma fórmula).
--   - Fuera: canal (en las compras siempre "Tienda").
-- =============================================================================

with compras as (

    select * from {{ ref('stg_erp__operaciones') }}
    where tipo_operacion = 'COMPRA'

),

monedas as (

    select valor_original, valor_limpio
    from {{ ref('diccionario_valores') }}
    where campo = 'moneda'

)

select
      c.id_operacion                                                                       as id_compra
    , c.id_reloj_fisico
    , c.id_contacto
    , {{ dbt_utils.generate_surrogate_key(['upper(c.empleado_original)', 'c.id_tienda']) }}  as id_empleado
    , c.fecha_operacion                                                                    as fecha_compra
    , c.importe
    , m.valor_limpio                                                                       as codigo_moneda
from compras c
left join monedas m
    on upper(trim(c.moneda_original)) = m.valor_original
