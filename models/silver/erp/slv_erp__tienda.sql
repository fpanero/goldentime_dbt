-- =============================================================================
-- slv_erp__tienda · 1 fila = una tienda o el canal online (13)
-- Silver: el origen ya viene limpio (comprobado). Solo se fija el nombre de
-- la columna de moneda, que en el modelo lógico es FK a moneda.
-- =============================================================================

with tiendas as (

    select * from {{ ref('stg_erp__tiendas') }}

)

select
      id_tienda
    , nombre_tienda
    , ciudad
    , pais
    , codigo_moneda
    , fecha_apertura
from tiendas
