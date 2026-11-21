-- =============================================================================
-- slv_erp__venta · 1 fila = una venta (142.301)
-- Silver: las filas VENTA de operaciones.
--   - Duplicados: 716 ventas están dos veces (misma pieza, mismos datos, otro
--     id de operación). Un reloj se vende una sola vez: se queda la de menor
--     id_operacion (qualify row_number, como en la plantilla del curso).
--   - Moneda unificada con el seed diccionario_valores.
--   - id_contacto admite NULL: 1.753 ventas sin cliente identificado.
--   - Fuera: descuento_pct. Se calcula con precio_lista e importe, y en el
--     ERP trae 318 negativos imposibles.
-- =============================================================================

with ventas as (

    select * from {{ ref('stg_erp__operaciones') }}
    where tipo_operacion = 'VENTA'

),

monedas as (

    select valor_original, valor_limpio
    from {{ ref('diccionario_valores') }}
    where campo = 'moneda'

)

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
from ventas v
left join monedas m
    on upper(trim(v.moneda_original)) = m.valor_original
qualify row_number() over (partition by v.id_reloj_fisico order by v.id_operacion) = 1
