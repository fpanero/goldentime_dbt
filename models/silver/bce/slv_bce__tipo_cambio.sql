-- =============================================================================
-- slv_bce__tipo_cambio · 1 fila = una moneda en un día hábil (5.379)
-- Silver:
--   - Solo CHF, GBP y USD: las monedas del negocio
--   - Solo de 2019 en adelante: los años del negocio.
-- =============================================================================

with tipos as (

    select fecha, chf_por_euro, gbp_por_euro, usd_por_euro
    from {{ ref('stg_bce__tipos_cambio') }}
    where fecha >= '2019-01-01'

),

en_filas as (

    select *
    from tipos
        unpivot (unidades_por_euro for columna_moneda in (chf_por_euro, gbp_por_euro, usd_por_euro))

)

select
      fecha
    , upper(split_part(columna_moneda, '_', 1))   as codigo_moneda   -- CHF_POR_EURO → CHF
    , unidades_por_euro
from en_filas
