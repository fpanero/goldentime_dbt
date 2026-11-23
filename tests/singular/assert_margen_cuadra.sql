-- El margen guardado es venta − compra − taller. (min son 5 centimos)

select id_venta, margen_real_eur
from {{ ref('fct_ventas') }}
where abs(margen_real_eur
          - (precio_venta_eur - precio_compra_eur
             - coste_revision_eur - coste_pulido_eur - coste_cambio_piezas_eur)) > 0.05