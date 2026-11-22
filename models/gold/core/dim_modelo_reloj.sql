-- Una fila = un modelo del catálogo. La marca va dentro (estrella, no copo de nieve).
-- num_anuncios_mercado: cuántos anuncios de Chrono24 respaldan su precio de mercado (para filtrar).

select
      mo.id_modelo_reloj
    , mo.referencia
    , mo.nombre_modelo
    , ma.nombre_marca              as marca
    , me.num_anuncios_mercado
from {{ ref('slv_erp__modelo_reloj') }} mo
inner join {{ ref('slv_erp__marca') }} ma
    on mo.id_marca = ma.id_marca
left join {{ ref('int_mercado__por_modelo') }} me
    on mo.id_modelo_reloj = me.id_modelo_reloj
