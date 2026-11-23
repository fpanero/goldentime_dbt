-- 3.1 ¿Cuánto pagamos frente a la mediana de Chrono24 de ese modelo?
-- Solo compras de 2023: la foto de Chrono24 es de julio de 2023.

select
      m.marca
    , count(*)                                                                   as compras_2023
    , round(avg(c.precio_compra_eur))                                            as precio_pagado_medio_eur
    , round(avg(c.precio_mercado_eur))                                           as precio_mercado_medio_eur
    , round((sum(c.precio_compra_eur) / sum(c.precio_mercado_eur) - 1) * 100, 1) as diferencia_pct
    , min(m.num_anuncios_mercado)                                                as min_anuncios_por_modelo
from {{ ref('fct_compras') }} c
inner join {{ ref('dim_modelo_reloj') }} m on c.id_modelo_reloj = m.id_modelo_reloj
inner join {{ ref('dim_fecha') }} f        on c.fecha_compra_key = f.fecha_key
where f.anio = 2023
  and c.precio_mercado_eur is not null
group by m.marca
order by diferencia_pct desc
