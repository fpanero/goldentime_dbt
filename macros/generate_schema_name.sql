{#-
    Decide en qué schema se crea cada modelo.

    · En el IDE (target "default"): schema personal con prefijo
        dbt_fpanero + erp  → dbt_fpanero_erp
    · En los jobs de DEV y PRO (target name dev / pro): solo el
      +schema → erp, silver, core...
-#}
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set invocation_context = env_var('DBT_CLOUD_INVOCATION_CONTEXT', '') -%}

    {%- if custom_schema_name is none -%}
        {{ target.schema }}

    {%- elif invocation_context != 'ci' and target.name in ['dev', 'pro'] -%}
        {{ custom_schema_name | trim }}

    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
