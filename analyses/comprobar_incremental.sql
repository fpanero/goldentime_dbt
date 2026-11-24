-- Comprobar el incremental de fct_ventas desde dbt (Preview).
-- Una fila por carga: cuándo llegó a Bronze y cuántas ventas trajo.
-- Antes del build, la última carga no aparece aún en Gold; después, sí, con su número exacto.

select
      date_trunc('minute', loaded_at)          as carga
    , count(*)                                 as ventas
    , min(id_venta)                            as primer_id
    , max(id_venta)                            as ultimo_id
from {{ ref('fct_ventas') }}
group by 1
order by 1
