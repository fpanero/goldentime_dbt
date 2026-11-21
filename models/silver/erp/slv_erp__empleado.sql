-- =============================================================================
-- slv_erp__empleado · 1 fila = un empleado que ha firmado operaciones (142)
-- Silver: el ERP no exporta la ficha de RR. HH.; solo el nombre de quien firma
-- cada compra o venta. Aquí ese texto pasa a ser una entidad con clave.
--   - Clave natural = nombre + tienda 
-- =============================================================================

with operaciones as (

    select
          upper(empleado_original)  as nombre_clave   
        , empleado_original
        , id_tienda
    from {{ ref('stg_erp__operaciones') }}
    where empleado_original is not null

)

select
      {{ dbt_utils.generate_surrogate_key(['nombre_clave', 'id_tienda']) }}  as id_empleado
    , mode(empleado_original)                                               as nombre_empleado
    , id_tienda
from operaciones
group by nombre_clave, id_tienda
