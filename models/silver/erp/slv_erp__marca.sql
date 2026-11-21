-- =============================================================================
-- slv_erp__marca · 1 fila = una marca (18)
-- Silver: la marca llega como texto repetido en cada referencia del catálogo;
-- aquí pasa a ser una tabla propia (3FN, entidad del modelo conceptual).
-- Clave subrogada con dbt_utils.generate_surrogate_key (hash del nombre):
-- siempre sale la misma para la misma marca, aunque se reconstruya la tabla.
-- =============================================================================

with referencias as (

    select * from {{ ref('stg_erp__referencias') }}

),

marcas as (

    select distinct nombre_marca
    from referencias
    where nombre_marca is not null

)

select
      {{ dbt_utils.generate_surrogate_key(['nombre_marca']) }}  as id_marca
    , nombre_marca
from marcas
