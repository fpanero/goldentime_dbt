-- Una fila = un día de 2019 a 2026. Calendario común a los dos hechos.

with dias as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2019-01-01' as date)",
        end_date="cast('2027-01-01' as date)"
    ) }}

)

select
      to_number(to_char(date_day, 'YYYYMMDD'))            as fecha_key
    , cast(date_day as date)                              as fecha
    , year(date_day)                                      as anio
    , quarter(date_day)                                   as trimestre
    , month(date_day)                                     as mes
    , decode(month(date_day),
          1, 'Enero', 2, 'Febrero', 3, 'Marzo', 4, 'Abril', 5, 'Mayo', 6, 'Junio',
          7, 'Julio', 8, 'Agosto', 9, 'Septiembre', 10, 'Octubre', 11, 'Noviembre', 12, 'Diciembre')
                                                          as nombre_mes
    , decode(dayofweekiso(date_day),
          1, 'Lunes', 2, 'Martes', 3, 'Miércoles', 4, 'Jueves', 5, 'Viernes', 6, 'Sábado', 7, 'Domingo')
                                                          as dia_semana
    , dayofweekiso(date_day) in (6, 7)                    as es_fin_de_semana
from dias