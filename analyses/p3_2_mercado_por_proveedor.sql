-- 3.2 ¿Dónde pagamos de más: a particulares o a dealers?
-- Solo compras de 2023 (foto de Chrono24 de julio de 2023).

select
      c.tipo_proveedor
    , count(*)                                                                   as compras_2023
    , round((sum(c.precio_compra_eur) / sum(c.precio_mercado_eur) - 1) * 100, 1) as diferencia_pct
from {{ ref('fct_compras') }} c
inner join {{ ref('dim_fecha') }} f on c.fecha_compra_key = f.fecha_key
where f.anio = 2023
  and c.precio_mercado_eur is not null
group by c.tipo_proveedor
