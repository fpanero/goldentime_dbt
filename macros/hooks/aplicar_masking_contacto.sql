-- Vuelve a poner la masking policy en los datos personales de contacto.
-- dbt recrea la tabla en cada build y la política se perdería.

{% macro aplicar_masking_contacto() %}
    {% set gobierno = env_var('DBT_SILVER_DB') ~ '.governance' %}
    alter table {{ this }}
        modify column nombre    set masking policy {{ gobierno }}.pii_texto,
               column apellidos set masking policy {{ gobierno }}.pii_texto,
               column email     set masking policy {{ gobierno }}.pii_email,
               column telefono  set masking policy {{ gobierno }}.pii_texto
{% endmacro %}