-- Una fila = una moneda en cada día de 2019 a 2025 (también fines de semana y festivos).
-- El BCE solo publica días hábiles: los huecos toman el último tipo publicado
-- (y el 01/01/2019, sin tipo anterior, el siguiente). EUR = 1 para unir igual todas las operaciones.

with dias as (

    select fecha from {{ ref('dim_fecha') }}

),

monedas as (

    select codigo_moneda from {{ ref('moneda') }}
    where codigo_moneda <> 'EUR'

),

publicados as (

    select fecha, codigo_moneda, unidades_por_euro
    from {{ ref('slv_bce__tipo_cambio') }}

),

rellenos as (

    select
          d.fecha
        , m.codigo_moneda
        , coalesce(
              last_value(p.unidades_por_euro ignore nulls) over (
                  partition by m.codigo_moneda order by d.fecha
                  rows between unbounded preceding and current row)
            , first_value(p.unidades_por_euro ignore nulls) over (
                  partition by m.codigo_moneda order by d.fecha
                  rows between current row and unbounded following)
          )                                                   as unidades_por_euro
    from dias d
    cross join monedas m
    left join publicados p
        on  p.fecha = d.fecha
        and p.codigo_moneda = m.codigo_moneda

)

select fecha, codigo_moneda, unidades_por_euro from rellenos
union all
select fecha, 'EUR', 1 from dias
