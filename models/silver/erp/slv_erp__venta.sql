-- Una fila = una venta (142.301). Ventas sin duplicados y con la moneda unificada.
-- Incremental: lee las filas llegadas a Bronze (loaded_at)
-- desde 1 hora antes de la última carga ya procesada, para recoger lo que llegó tarde.
-- El merge por id_venta evita duplicar las que se vuelven a leer.

{{ config(
    materialized='incremental',
    unique_key='id_venta',
    incremental_strategy='merge'
) }}

with ventas as (

    select * from {{ ref('stg_erp__operaciones') }}
    where tipo_operacion = 'VENTA'
    {% if is_incremental() %}
      and loaded_at > (select dateadd('hour', -1, max(loaded_at)) from {{ this }})
    {% endif %}

),

monedas as (

    select valor_original, valor_limpio
    from {{ ref('diccionario_valores') }}
    where campo = 'moneda'

),

limpias as (

    select
          v.id_operacion                                                                       as id_venta
        , v.id_reloj_fisico
        , v.id_contacto
        , {{ dbt_utils.generate_surrogate_key(['upper(v.empleado_original)', 'v.id_tienda']) }}  as id_empleado
        , v.fecha_operacion                                                                    as fecha_venta
        , v.canal_original                                                                     as canal
        , v.precio_lista
        , v.importe
        , m.valor_limpio                                                                       as codigo_moneda
        , v.loaded_at
    from ventas v
    left join monedas m
        on upper(trim(v.moneda_original)) = m.valor_original
    -- un reloj se vende una vez: de las duplicadas, la de menor id
    qualify row_number() over (partition by v.id_reloj_fisico order by v.id_operacion) = 1

)

select * from limpias l
{% if is_incremental() %}
-- una venta duplicada que llega tarde, de un reloj ya vendido, no entra
where not exists (
    select 1 from {{ this }} t
    where t.id_reloj_fisico = l.id_reloj_fisico
      and t.id_venta <> l.id_venta
)
{% endif %}
