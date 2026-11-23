-- 1.3 ¿Ganamos más comprando a particulares o a dealers?

select
      tipo_proveedor
    , count(*)                                                         as relojes_vendidos
    , round(sum(margen_real_eur))                                      as margen_real_eur
    , round(sum(margen_real_eur) / sum(precio_venta_eur) * 100, 1)     as margen_pct
    , round(avg(margen_real_eur))                                      as margen_medio_por_reloj_eur
from {{ ref('fct_ventas') }}
group by tipo_proveedor
