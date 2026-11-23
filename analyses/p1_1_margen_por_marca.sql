-- 1.1 ¿Qué margen real deja cada marca?

select
      m.marca
    , count(*)                                                       as relojes_vendidos
    , round(sum(v.margen_real_eur))                                  as margen_real_eur
    , round(sum(v.margen_real_eur) / sum(v.precio_venta_eur) * 100, 1) as margen_pct
    , round(avg(v.margen_real_eur))                                  as margen_medio_por_reloj_eur
from {{ ref('fct_ventas') }} v
inner join {{ ref('dim_modelo_reloj') }} m on v.id_modelo_reloj = m.id_modelo_reloj
group by m.marca
order by margen_real_eur desc
