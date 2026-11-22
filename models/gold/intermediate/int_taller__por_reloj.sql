-- Una fila = un reloj que pasó por taller. Coste por tipo de intervención (sin coste anotado = 0).

select
      id_reloj_fisico
    , sum(case when tipo_intervencion = 'Revisión completa' then coalesce(coste_eur, 0) else 0 end)  as coste_revision_eur
    , sum(case when tipo_intervencion = 'Pulido'            then coalesce(coste_eur, 0) else 0 end)  as coste_pulido_eur
    , sum(case when tipo_intervencion = 'Cambio de piezas'  then coalesce(coste_eur, 0) else 0 end)  as coste_cambio_piezas_eur
    , count(*)                                                                                      as num_intervenciones
from {{ ref('slv_erp__intervencion') }}
group by id_reloj_fisico
