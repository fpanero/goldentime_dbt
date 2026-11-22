-- Una fila = una venta. Importes en euros al tipo de cambio del día de cada operación.
-- Incremental: cada ejecución procesa solo las ventas nuevas (y repasa los últimos 7 días).

{{ config(
    materialized='incremental',
    unique_key='id_venta',
    incremental_strategy='merge'
) }}

with ventas as (

    select * from {{ ref('slv_erp__venta') }}
    {% if is_incremental() %}
    where fecha_venta >= (
        select dateadd(day, -7, to_date(to_varchar(max(fecha_venta_key)), 'YYYYMMDD'))
        from {{ this }}
    )
    {% endif %}

),

compras as (

    select * from {{ ref('slv_erp__compra') }}

),

relojes as (

    select * from {{ ref('slv_erp__reloj_fisico') }}

),

proveedores as (

    select id_contacto, tipo_contacto from {{ ref('slv_erp__contacto') }}

),

taller as (

    select * from {{ ref('int_taller__por_reloj') }}

),

rebajas as (

    select * from {{ ref('int_rebajas__por_reloj') }}

),

tipos as (

    select * from {{ ref('int_tipo_cambio__diario') }}

),

unidas as (

    select
          v.id_venta
        , v.fecha_venta
        , c.fecha_compra
        , v.id_reloj_fisico
        , r.id_modelo_reloj
        , r.id_tienda
        , p.tipo_contacto                                                  as tipo_proveedor
        , v.canal
        , c.importe / tc.unidades_por_euro                                 as precio_compra_eur
        , v.importe / tv.unidades_por_euro                                 as precio_venta_eur
        , coalesce(t.coste_revision_eur, 0)                                as coste_revision_eur
        , coalesce(t.coste_pulido_eur, 0)                                  as coste_pulido_eur
        , coalesce(t.coste_cambio_piezas_eur, 0)                           as coste_cambio_piezas_eur
        , coalesce(t.num_intervenciones, 0)                                as num_intervenciones
        -- mismo tipo que la venta: el % de rebaja mide solo la rebaja, no la divisa
        , coalesce(rb.primer_precio_vitrina, v.precio_lista) / tv.unidades_por_euro
                                                                           as primer_precio_vitrina_eur
        , coalesce(rb.num_rebajas, 0)                                      as num_rebajas
    from ventas v
    inner join compras c      on v.id_reloj_fisico = c.id_reloj_fisico
    inner join relojes r      on v.id_reloj_fisico = r.id_reloj_fisico
    inner join proveedores p  on c.id_contacto     = p.id_contacto
    inner join tipos tv       on tv.fecha = v.fecha_venta  and tv.codigo_moneda = v.codigo_moneda
    inner join tipos tc       on tc.fecha = c.fecha_compra and tc.codigo_moneda = c.codigo_moneda
    left join taller t        on v.id_reloj_fisico = t.id_reloj_fisico
    left join rebajas rb      on v.id_reloj_fisico = rb.id_reloj_fisico

)

select
      id_venta
    , to_number(to_char(fecha_venta, 'YYYYMMDD'))                         as fecha_venta_key
    , to_number(to_char(fecha_compra, 'YYYYMMDD'))                        as fecha_compra_key
    , id_reloj_fisico
    , id_modelo_reloj
    , id_tienda
    , tipo_proveedor
    , canal
    , round(precio_compra_eur, 2)                                         as precio_compra_eur
    , round(precio_venta_eur, 2)                                          as precio_venta_eur
    , round(precio_venta_eur - precio_compra_eur
            - coste_revision_eur - coste_pulido_eur - coste_cambio_piezas_eur, 2)
                                                                          as margen_real_eur
    , coste_revision_eur
    , coste_pulido_eur
    , coste_cambio_piezas_eur
    , num_intervenciones
    , round(primer_precio_vitrina_eur, 2)                                 as primer_precio_vitrina_eur
    , num_rebajas
    , datediff(day, fecha_compra, fecha_venta)                            as dias_en_stock
from unidas
