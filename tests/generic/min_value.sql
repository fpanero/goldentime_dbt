-- Test genérico propio: falla si algún valor de la columna es menor que `value` (por defecto 0).

{% test min_value(model, column_name, value=0) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} < {{ value }}

{% endtest %}