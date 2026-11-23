-- 2.2 ¿Cuántos relojes llevan más de 180 días sin venderse y cuánto dinero hay parado en ellos?
-- Stock = compras con dias_sin_vender relleno (sin venta a 31/12/2025).

select
      t.nombre_tienda
    , case
          when c.dias_sin_vender <= 90  then '1. 0–90 días'
          when c.dias_sin_vender <= 180 then '2. 90–180 días'
          else '3. más de 180 días'
      end                                    as tramo
    , count(*)                               as relojes_en_stock
    , round(sum(c.precio_compra_eur))        as dinero_parado_eur
from {{ ref('fct_compras') }} c
inner join {{ ref('dim_tienda') }} t on c.id_tienda = t.id_tienda
where c.dias_sin_vender is not null
group by t.nombre_tienda, tramo
order by t.nombre_tienda, tramo
