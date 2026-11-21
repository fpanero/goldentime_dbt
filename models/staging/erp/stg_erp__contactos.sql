-- =============================================================================
-- stg_erp__contactos · 1 fila = un contacto del CRM (60.249)
-- Staging: 1:1 con Bronze en filas Y columnas (las 14). Solo renombrar y
-- poner tipos.
-- =============================================================================

with source as (

    select * from {{ source('erp', 'contactos') }}

),

renamed as (

    select
          to_number(contacto_id)                    as id_contacto
        , trim(tipo_contacto)                       as tipo_contacto      -- Particular | Dealer
        , trim(nombre)                              as nombre
        , trim(apellidos)                           as apellidos
        , trim(email)                               as email
        , trim(telefono)                            as telefono
        , trim(pais)                                as pais               -- tal cual: se unifica en Silver
        , trim(ciudad)                              as ciudad
        , trim(tipo_cliente)                        as tipo_cliente
        , {{ texto_a_booleano('es_vip') }}          as es_vip             -- S/N → true/false
        , to_number(tienda_habitual_id)             as id_tienda_habitual
        , upper(trim(moneda_habitual))              as moneda_habitual    -- 99,5 % vacío (solo dealers)
        , try_to_decimal(valoracion, 3, 1)          as valoracion         -- 99,5 % vacío (solo dealers)
        , {{ texto_a_fecha('fecha_alta') }}         as fecha_alta
        , _fichero_origen                           as fichero_origen
        , _loaded_at                                as loaded_at
    from source

)

select * from renamed
