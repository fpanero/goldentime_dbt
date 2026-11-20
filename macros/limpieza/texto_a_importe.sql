{#-
    texto_a_importe(columna)
    Convierte a NUMBER(12,2) un importe del ERP que puede venir como:
        12500  /  12500.0      número normal (punto decimal)
        12.500,00 €            formato español: punto de miles, coma decimal
        £18,900 · CHF 5,119 · $3,463   formato inglés: coma de miles
    Regla: si lleva "€", el punto es de miles y la coma decimal; si no, la
    coma es de miles y se quita. Comprobado en los 293.017 importes: ninguno
    queda NULL y la venta nunca supera su precio de lista.
    Dinero en NUMBER, nunca FLOAT (convención del curso).
-#}
{% macro texto_a_importe(columna) -%}
    case
        when {{ columna }} like '%€%'
            then try_to_decimal(
                     replace(replace(trim(replace({{ columna }}, '€', '')), '.', ''), ',', '.'),
                     12, 2)
        else try_to_decimal(regexp_replace({{ columna }}, '[^0-9.]', ''), 12, 2)
    end
{%- endmacro %}
