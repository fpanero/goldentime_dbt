{#-
    texto_a_fecha(columna)
    Convierte a DATE una fecha del ERP que puede venir en 4 formatos
    Se mira el formato con una expresión regular antes de convertir: así una
    fecha nunca se lee con el formato equivocado. Si no encaja en ninguno,
    devuelve NULL.
-#}
{% macro texto_a_fecha(columna) -%}
    case
        when regexp_like(trim({{ columna }}), '^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
            then to_date(trim({{ columna }}), 'YYYY-MM-DD')
        when regexp_like(trim({{ columna }}), '^[0-9]{2}/[0-9]{2}/[0-9]{4}$')
            then to_date(trim({{ columna }}), 'DD/MM/YYYY')
        when regexp_like(trim({{ columna }}), '^[0-9]{2}-[0-9]{2}-[0-9]{2}$')
            then to_date(trim({{ columna }}), 'DD-MM-YY')
        when regexp_like(trim({{ columna }}), '^[0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}$')
            then to_date(to_timestamp(trim({{ columna }}), 'YYYY/MM/DD HH24:MI'))
    end
{%- endmacro %}
