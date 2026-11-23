-- 2.1 ¿Cuántos días tarda en venderse un reloj? ¿Influyen el estado, la caja y los papeles?

select
      r.estado
    , r.tiene_caja
    , r.tiene_papeles
    , count(*)                          as relojes_vendidos
    , round(avg(v.dias_en_stock))       as dias_media
    , median(v.dias_en_stock)           as dias_mediana
from {{ ref('fct_ventas') }} v
inner join {{ ref('dim_reloj') }} r on v.id_reloj_fisico = r.id_reloj_fisico
group by r.estado, r.tiene_caja, r.tiene_papeles
order by dias_media desc
