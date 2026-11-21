-- =============================================================================
-- slv_erp__intervencion · 1 fila = un paso de un reloj por el taller (77.561)
-- Silver: las filas TALLER de historial_pieza (la otra mitad, CAMBIO_PRECIO,
-- va a slv_erp__cambio_precio.
--  - Fuera: precio_anterior, precio_nuevo y moneda (vacías en el taller).
-- =============================================================================

with taller as (

    select * from {{ ref('stg_erp__historial_pieza') }}
    where tipo_evento = 'TALLER'

)

select
      id_evento                                                         as id_intervencion
    , id_reloj_fisico
    , detalle                                                           as tipo_intervencion
    , lugar_taller
    , fecha_evento                                                      as fecha_entrada
    , case when fecha_fin >= fecha_evento then fecha_fin end            as fecha_salida
    , coste_eur
from taller
