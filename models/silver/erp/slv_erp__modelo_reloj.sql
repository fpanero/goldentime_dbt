-- =============================================================================
-- slv_erp__modelo_reloj · 1 fila = un modelo del catálogo (1.497)
-- Silver: limpia y deduplica el catálogo.
--   1. Normaliza la referencia (macro normalizar_referencia).
--   2. Corrige las erratas del nombre del modelo (seed correccion_nombre_modelo).
--   3. Deduplica: 69 referencias están repetidas con otra escritura y 3 de
--      Panerai vienen así del catálogo real. Clave natural = marca + referencia
--      (79160 y 79190 existen en Rolex Y en Tudor). Se queda la fila original
--      del catálogo: la de menor id_referencia.
-- Las compras que apuntan a una copia se reasignan en slv_erp__reloj_fisico.
-- =============================================================================

with referencias as (

    select * from {{ ref('stg_erp__referencias') }}

),

marcas as (

    select * from {{ ref('slv_erp__marca') }}

),

correcciones as (

    select * from {{ ref('correccion_nombre_modelo') }}

),

limpias as (

    select
          r.id_referencia                                       as id_modelo_reloj
        , m.id_marca
        , {{ normalizar_referencia('r.referencia_original') }}  as referencia
        , coalesce(c.nombre_correcto, r.nombre_modelo)          as nombre_modelo
        , r.material_caja
        , r.material_brazalete
        , r.movimiento
        , r.diametro_mm
        , r.genero
    from referencias r
    inner join marcas m
        on r.nombre_marca = m.nombre_marca
    left join correcciones c
        on r.nombre_modelo = c.nombre_erroneo

)

select *
from limpias
qualify row_number() over (
    partition by id_marca, referencia
    order by id_modelo_reloj
) = 1
