-- =============================================================================
-- slv_bce__tipo_cambio · 1 fila = una moneda en un día hábil (5.379)
-- Silver:
--   - Solo CHF, GBP y USD: las monedas del negocio (EUR no necesita tipo:
--     vale 1). Las otras 38 se quedan en staging y Bronze.
--   - Solo 2019–2025: los años del negocio.
--   - De ancho (una columna por moneda) a largo (una fila por moneda y día)
--     con UNPIVOT de Snowflake: así es una tabla en 3FN con PK (fecha, moneda)
--     y se une a cualquier operación por fecha y moneda.
--   UNPIVOT descarta los NULL: un día sin cotización no genera fila.
-- =============================================================================

with tipos as (

    select fecha, chf_por_euro, gbp_por_euro, usd_por_euro
    from {{ ref('stg_bce__tipos_cambio') }}
    where fecha between '2019-01-01' and '2025-12-31'

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
