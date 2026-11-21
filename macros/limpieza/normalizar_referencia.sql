{#-
    normalizar_referencia(columna)
    Una misma referencia llega escrita de varias formas en el ERP y en Chrono24:
        126334 · M126334-0001 · iw3 88102 · PAM 01085 · pam01085
    Regla: sin espacios, en mayúsculas y sin el formato M......-0001.
    Se usa en 3 modelos (modelo_reloj, reloj_fisico y anuncio_mercado): si la
    regla cambia, cambia en los tres a la vez. Comprobada en el script 04
    (1.569 filas del catálogo → 1.497 modelos).
-#}
{% macro normalizar_referencia(columna) -%}
    regexp_replace(
        upper(regexp_replace({{ columna }}, '\\s', '')),
        '^M([0-9A-Z]+)-[0-9]{4}$', '\\1'
    )
{%- endmacro %}
