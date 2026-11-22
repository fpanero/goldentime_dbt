-- Una fila = una tienda o el canal online.

select
      id_tienda
    , nombre_tienda
    , ciudad
    , pais
    , codigo_moneda     as moneda_local
from {{ ref('slv_erp__tienda') }}
