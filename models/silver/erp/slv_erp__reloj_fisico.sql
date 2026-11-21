-- =============================================================================
-- slv_erp__reloj_fisico · 1 fila = un reloj concreto (150.000)
-- Silver: sale de las filas COMPRA de operaciones (cada reloj entra una vez).
--   - Modelo: la compra apunta a una referencia del catálogo, y 2.114 compras
--     apuntan a una COPIA que se quitó en slv_erp__modelo_reloj. Se reasignan
--     al modelo bueno buscando por marca + referencia normalizada (la misma
--     macro normalizar_referencia).
--   - Estado: 18 escrituras ("MB", "Very good", "MUY BUENO"...) → 5 valores,
--     con el seed diccionario_valores.
--   - Año de fabricación imposible (0, 19, 1900, 2031, 9999) → NULL. Válido:
--     de 1950 al año de la compra.
--   - Tienda: el reloj se compra y se vende siempre en la misma (comprobado),
--     por eso vive aquí y no en compra ni en venta.
-- =============================================================================

with compras as (

    select * from {{ ref('stg_erp__operaciones') }}
    where tipo_operacion = 'COMPRA'

),

referencias as (

    select * from {{ ref('stg_erp__referencias') }}

),

marcas as (

    select * from {{ ref('slv_erp__marca') }}

),

modelos as (

    select * from {{ ref('slv_erp__modelo_reloj') }}

),

estados as (

    select valor_original, valor_limpio
    from {{ ref('diccionario_valores') }}
    where campo = 'estado'

),

-- cada id_referencia del ERP (también las copias) → su modelo bueno
referencia_a_modelo as (

    select
          r.id_referencia
        , mo.id_modelo_reloj
    from referencias r
    inner join marcas ma
        on r.nombre_marca = ma.nombre_marca
    inner join modelos mo
        on  mo.id_marca   = ma.id_marca
        and mo.referencia = {{ normalizar_referencia('r.referencia_original') }}

)

select
      c.id_reloj_fisico
    , c.numero_serie
    , rm.id_modelo_reloj
    , c.id_tienda
    , case when c.anio_fabricacion between 1950 and year(c.fecha_operacion)
           then c.anio_fabricacion end                                  as anio_fabricacion
    , e.valor_limpio                                                    as estado
    , c.tiene_caja
    , c.tiene_papeles
from compras c
left join referencia_a_modelo rm
    on c.id_referencia = rm.id_referencia
left join estados e
    on upper(trim(c.estado_original)) = e.valor_original
