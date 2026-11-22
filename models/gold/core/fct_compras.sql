-- Una fila = una compra, vendida o no. Importe en euros al tipo del día de la compra.
-- dias_sin_vender: días en tienda a 31/12/2025 (fin del histórico); NULL si el reloj se vendió.

with compras as (

    select * from {{ ref('slv_erp__compra') }}

),

relojes as (

    select * from {{ ref('slv_erp__reloj_fisico') }}

),

proveedores as (

    select id_contacto, tipo_contacto from {{ ref('slv_erp__contacto') }}

),

vendidos as (

    select id_reloj_fisico from {{ ref('slv_erp__venta') }}

),

tipos as (

    select * from {{ ref('int_tipo_cambio__diario') }}

),

mercado as (

    select * from {{ ref('int_mercado__por_modelo') }}

)

select
      c.id_compra
    , to_number(to_char(c.fecha_compra, 'YYYYMMDD'))                      as fecha_compra_key
    , c.id_reloj_fisico
    , r.id_modelo_reloj
    , r.id_tienda
    , p.tipo_contacto                                                     as tipo_proveedor
    , round(c.importe / tc.unidades_por_euro, 2)                          as precio_compra_eur
    , m.precio_mercado_eur
    , case when v.id_reloj_fisico is null
           then datediff(day, c.fecha_compra, '2025-12-31'::date) end     as dias_sin_vender
from compras c
inner join relojes r      on c.id_reloj_fisico = r.id_reloj_fisico
inner join proveedores p  on c.id_contacto     = p.id_contacto
inner join tipos tc       on tc.fecha = c.fecha_compra and tc.codigo_moneda = c.codigo_moneda
left join vendidos v      on c.id_reloj_fisico = v.id_reloj_fisico
left join mercado m       on r.id_modelo_reloj = m.id_modelo_reloj
