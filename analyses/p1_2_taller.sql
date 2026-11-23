-- 1.2 ¿Qué parte del margen se come el taller y qué tipo de intervención se lleva más dinero?

select
      m.marca
    , round(sum(v.coste_revision_eur))                                as revision_eur
    , round(sum(v.coste_pulido_eur))                                  as pulido_eur
    , round(sum(v.coste_cambio_piezas_eur))                           as cambio_piezas_eur
    , round(sum(v.coste_revision_eur + v.coste_pulido_eur + v.coste_cambio_piezas_eur)
            / sum(v.precio_venta_eur - v.precio_compra_eur) * 100, 1) as taller_sobre_margen_bruto_pct
from {{ ref('fct_ventas') }} v
inner join {{ ref('dim_modelo_reloj') }} m on v.id_modelo_reloj = m.id_modelo_reloj
group by m.marca
order by taller_sobre_margen_bruto_pct desc
