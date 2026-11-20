-- =============================================================================
-- stg_bce__tipos_cambio · 1 fila = un día hábil (7.092, de 1999 a 2026)
-- Staging: 1:1 con Bronze en filas Y columnas: las 41 monedas.
-- Para no escribir 41 líneas iguales, un bucle de Jinja genera una columna
-- por moneda (lo que se compila es SQL normal: míralo en "Compiled code").
-- Elegir CHF, GBP y USD, pasar a filas (unpivot) y filtrar 2019–2025 se hace
-- en Silver.
-- =============================================================================

{%- set monedas = [
    'usd', 'jpy', 'bgn', 'cyp', 'czk', 'dkk', 'eek', 'gbp', 'huf', 'ltl', 'lvl',
    'mtl', 'pln', 'rol', 'ron', 'sek', 'sit', 'skk', 'chf', 'isk', 'nok', 'hrk',
    'rub', 'trl', 'try', 'aud', 'brl', 'cad', 'cny', 'hkd', 'idr', 'ils', 'inr',
    'krw', 'mxn', 'myr', 'nzd', 'php', 'sgd', 'thb', 'zar'
] %}

with source as (

    select * from {{ source('bce', 'tipos_cambio') }}

),

renamed as (

    select
          to_date(date)                                 as fecha
        -- 1 EUR = x moneda. try_to_decimal: "N/A" o vacío pasa a NULL
        {%- for m in monedas %}
        , try_to_decimal({{ m }}, 18, 6)                as {{ m }}_por_euro
        {%- endfor %}
        , _fichero_origen                               as fichero_origen
        , _loaded_at                                    as loaded_at
    from source

)

select * from renamed
