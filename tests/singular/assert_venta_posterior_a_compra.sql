-- Ningún reloj se vende antes de comprarlo.

select id_venta, dias_en_stock
from {{ ref('fct_ventas') }}
where dias_en_stock < 0