-- ===========================================================================
-- ejercicios_modulo_19.sql
-- ===========================================================================
-- Las analyses son queries SQL que se compilan (sustituyen refs y sources)
-- pero NO se materializan en el DW. Útiles para:
--   - Queries ad-hoc que el equipo de datos usa con frecuencia
--   - Exploración previa antes de promover a un modelo
--   - Documentación ejecutable de cómo responder preguntas de negocio
--
-- Comando para compilar y ver el SQL resultante:
--   dbt compile --select analysis:ejercicios_modulo_19
--
-- ===========================================================================
-- EJERCICIO 1: ¿Cuántos usuarios tenemos?
-- ===========================================================================

select count(*) as total_users
from {{ ref('dim_users') }};

-- ===========================================================================
-- EJERCICIO 2: En promedio, ¿cuánto tarda un pedido entre creación y entrega?
-- ===========================================================================

select
      avg(days_to_deliver) as avg_days_to_deliver
    , min(days_to_deliver) as min_days_to_deliver
    , max(days_to_deliver) as max_days_to_deliver
from {{ ref('fct_orders') }}
where delivered_at_utc is not null;

-- ===========================================================================
-- EJERCICIO 3: ¿Cuántos usuarios han realizado 1 / 2 / 3+ compras?
-- ===========================================================================

select
      purchase_segment
    , count(*) as num_users
from {{ ref('fct_user_purchases') }}
group by purchase_segment
order by num_users desc;

-- ===========================================================================
-- EJERCICIO 4: En promedio, ¿cuántas sesiones únicas tenemos por hora?
-- ===========================================================================

with sessions_by_hour as (

    select
          date_trunc('hour', session_start_at_utc) as hour
        , count(distinct session_id)               as sessions_in_hour
    from {{ ref('fct_user_sessions') }}
    group by 1

)

select avg(sessions_in_hour) as avg_sessions_per_hour
from sessions_by_hour;
