-- Una fila = un reloj con cambios de precio. Nº de rebajas y precio con el que salió a la venta
-- (el precio anterior a su primer cambio), en su moneda.

with cambios as (

    select * from {{ ref('slv_erp__cambio_precio') }}

),

primer_cambio as (

    select
          id_reloj_fisico
        , precio_anterior   as primer_precio_vitrina
        , codigo_moneda
    from cambios
    qualify row_number() over (
        partition by id_reloj_fisico
        order by fecha_cambio, id_cambio_precio
    ) = 1

),

rebajas as (

    select
          id_reloj_fisico
        , count_if(tipo_cambio = 'Rebaja')   as num_rebajas
    from cambios
    group by id_reloj_fisico

)

select
      p.id_reloj_fisico
    , r.num_rebajas
    , p.primer_precio_vitrina
    , p.codigo_moneda
from primer_cambio p
inner join rebajas r
    on p.id_reloj_fisico = r.id_reloj_fisico
