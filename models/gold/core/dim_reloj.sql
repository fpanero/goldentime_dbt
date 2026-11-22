-- Una fila = un reloj concreto, con lo que influye en su precio y su rotación.

select
      id_reloj_fisico
    , numero_serie
    , estado
    , tiene_caja
    , tiene_papeles
from {{ ref('slv_erp__reloj_fisico') }}
