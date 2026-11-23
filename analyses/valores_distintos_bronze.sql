-- Valores reales de las columnas que Silver unifica con el seed diccionario_valores.
-- De aquí salen las 18 escrituras del estado, las 14 de la moneda y las 34 del país.

select 'operaciones.estado' as columna, estado as valor, count(*) as filas
from {{ source('erp', 'operaciones') }}
where tipo_operacion = 'COMPRA'
group by all

union all

select 'operaciones.moneda', moneda, count(*)
from {{ source('erp', 'operaciones') }}
group by all

union all

select 'operaciones.canal', canal, count(*)
from {{ source('erp', 'operaciones') }}
where tipo_operacion = 'VENTA'
group by all

union all

select 'contactos.pais', pais, count(*)
from {{ source('erp', 'contactos') }}
group by all

order by columna, filas desc
