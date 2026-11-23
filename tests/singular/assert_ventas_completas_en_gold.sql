-- Todas las ventas de Silver llegan a fct_ventas: ningún join ni el incremental pierde filas.

select s.id_venta
from {{ ref('slv_erp__venta') }} s
left join {{ ref('fct_ventas') }} f
    on s.id_venta = f.id_venta
where f.id_venta is null