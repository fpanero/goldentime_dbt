-- =============================================================================
-- slv_erp__tienda · 1 fila = una tienda o el canal online (13)
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
