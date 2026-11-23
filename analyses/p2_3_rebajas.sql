-- 2.3 ¿Cuántas rebajas hacen falta antes de vender?

select
      m.marca
    , count(*)                                                                    as relojes_vendidos
    , round(avg(v.num_rebajas), 1)                                                as rebajas_medias
    , round((1 - sum(v.precio_venta_eur) / sum(v.primer_precio_vitrina_eur)) * 100, 1) as rebaja_acumulada_pct
from {{ ref('fct_ventas') }} v
inner join {{ ref('dim_modelo_reloj') }} m on v.id_modelo_reloj = m.id_modelo_reloj
group by m.marca
order by rebaja_acumulada_pct desc
