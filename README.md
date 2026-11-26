# GoldenTime · del dato sucio a la decisión

![GoldenTime](documentacion/img/pres_portada.jpg)

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?logo=dbt&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?logo=powerbi&logoColor=black)

**Proyecto final · Data Engineering · Cívica Software, 2026**

GoldenTime es un grupo europeo, ficticio, que compra y vende relojes de lujo de segunda mano. Tiene 12 tiendas, un canal online y siete años de datos sin explotar. Este proyecto convierte esos datos en respuestas de negocio.

> **Comprar bien → vender rápido → ganar más**

---

## Las preguntas

![Tres casos de uso](documentacion/img/pres_casos_de_uso.jpg)

| | Caso de uso | Pregunta |
|---|---|---|
| 1 | Margen real | ¿Cuánto ganamos de verdad? |
| 2 | Rotación | ¿Vendemos rápido? |
| 3 | Mercado | ¿Pagamos de más? |

## Los datos

| Fuente | Tipo | Filas |
|---|---|---|
| ERP de GoldenTime · 5 tablas | Ficticio | 919.057 |
| Chrono24 · anuncios de relojes | Real | 284.491 |
| BCE · tipos de cambio | Real | 7.092 |

## La arquitectura

![Arquitectura](documentacion/img/pres_arquitectura.jpg)

```mermaid
flowchart LR
    F[Fuentes<br/>ERP · Chrono24 · BCE] --> B[(Bronze<br/>7 tablas)]
    B --> ST[Staging<br/>7 vistas]
    ST --> S[(Silver<br/>12 tablas)]
    S --> G[(Gold<br/>2 hechos + 4 dims)]
    G --> P[Power BI]
```

## El modelado

**Silver**: cada tabla ancha del ERP, separada en sus entidades.

![Silver](documentacion/img/pres_silver.jpg)

**Gold**: esquema en estrella.

![Gold](documentacion/img/pres_gold_3d.jpg)

![Modelo dimensional](documentacion/img/modelo_dimensional_gold.jpg)

## dbt

![dbt](documentacion/img/pres_dbt_capas.jpg)

| 29 modelos | 3 seeds | 6 macros | 180 tests | 1 incremental en cadena |
|:---:|:---:|:---:|:---:|:---:|

## Las respuestas

![Respuestas](documentacion/img/pres_respuestas.jpg)

| Caso de uso | Respuesta |
|---|---|
| **Margen real** | 20,7 % de margen. Seiko pierde dinero (−14,6 %) por el taller. |
| **Rotación** | El estado manda: de 67 a 146 días. 12,1 M€ parados más de 180 días. |
| **Mercado** | Compramos un 24 % por debajo de Chrono24, sobre todo a particulares. |

## El dashboard

| | |
|---|---|
| ![Resumen](documentacion/img/dashboard_resumen.jpg) | ![Margen real](documentacion/img/dashboard_margen.jpg) |
| ![Rotación](documentacion/img/dashboard_rotacion.jpg) | ![¿Pagamos de más?](documentacion/img/dashboard_mercado.jpg) |

## La presentación

[GoldenTime_Presentacion.html](documentacion/presentacion/GoldenTime_Presentacion.html): descárgala y ábrela en el navegador. Funciona sin internet.

---

**Fran** · Data Engineer · Cívica Software
