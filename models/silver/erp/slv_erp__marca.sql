-- =============================================================================
-- slv_erp__marca · 1 fila = una marca (18)
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
