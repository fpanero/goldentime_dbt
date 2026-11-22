-- Una fila = un modelo del catálogo con anuncios en Chrono24 (julio 2023).
-- Mediana del precio pedido, pasada a euros con el tipo medio USD de julio de 2023.

with anuncios as (

    select id_modelo_reloj, precio_usd
    from {{ ref('slv_chrono24__anuncio_mercado') }}
    where id_modelo_reloj is not null
      and precio_usd is not null

),

usd_julio_2023 as (

    select avg(unidades_por_euro) as usd_por_euro
    from {{ ref('slv_bce__tipo_cambio') }}
    where codigo_moneda = 'USD'
      and fecha between '2023-07-01' and '2023-07-31'

)

select
      a.id_modelo_reloj
    , round(median(a.precio_usd) / t.usd_por_euro, 2)   as precio_mercado_eur
    , count(*)                                          as num_anuncios_mercado
from anuncios a
cross join usd_julio_2023 t
group by a.id_modelo_reloj, t.usd_por_euro
