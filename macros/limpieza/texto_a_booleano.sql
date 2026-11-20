{#-
    texto_a_booleano(columna)
    Convierte a BOOLEAN un sí/no del ERP escrito de 9 formas:
        S · Sí · SI · 1 · true   → TRUE
        N · No · 0 · false       → FALSE
        vacío                    → NULL (desconocido, no "no": Modelo_logico.md)
-#}
{% macro texto_a_booleano(columna) -%}
    case
        when upper(trim({{ columna }})) in ('S', 'SI', 'SÍ', '1', 'TRUE')  then true
        when upper(trim({{ columna }})) in ('N', 'NO', '0', 'FALSE')       then false
    end
{%- endmacro %}
