-- =============================================================================
-- slv_erp__contacto · 1 fila = un particular o un dealer (60.249)
-- Silver: limpia los valores del CRM. No une, no filtra.
--   - país: 34 escrituras ("ES", "Spain", "españa"...) → 14 países, con el
--     seed diccionario_valores.
--   - teléfono: 4 formatos → uno solo, internacional (+34600966230).
-- =============================================================================

{{ config(post_hook="{{ aplicar_masking_contacto() }}") }}

with contactos as (

    select * from {{ ref('stg_erp__contactos') }}

),

paises as (

    select valor_original, valor_limpio
    from {{ ref('diccionario_valores') }}
    where campo = 'pais'

),

limpios as (

    select
          c.id_contacto
        , c.tipo_contacto
        , case when c.tipo_contacto = 'Particular' and c.nombre = upper(c.nombre)
               then initcap(c.nombre) else c.nombre end                       as nombre
        , case when c.apellidos = upper(c.apellidos)
               then initcap(c.apellidos) else c.apellidos end                  as apellidos
        , nullif(lower(replace(replace(c.email, ' ', ''), '@@', '@')), '')     as email
        , case
              when nullif(c.telefono, '') is null           then null
              when c.telefono like '+%'                      then '+' || regexp_replace(c.telefono, '[^0-9]', '')
              when regexp_replace(c.telefono, '[^0-9]', '') like '00%'
                  then '+' || substr(regexp_replace(c.telefono, '[^0-9]', ''), 3)
              when length(regexp_replace(c.telefono, '[^0-9]', '')) = 9
                  then '+34' || regexp_replace(c.telefono, '[^0-9]', '')
          end                                                                  as telefono
        , p.valor_limpio                                                       as pais
        , nullif(c.ciudad, '')                                                 as ciudad
        , nullif(c.tipo_cliente, '')                                           as tipo_cliente
        , c.es_vip
        , c.id_tienda_habitual
        , c.fecha_alta
    from contactos c
    left join paises p
        on upper(c.pais) = p.valor_original

)

select
      *
    , regexp_like(email, '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$')          as es_email_valido
from limpios
