-- Silver incremental: una fila por orden, con su última versión (estado final).
-- Lee solo lo cargado en Bronze después de la última carga; el merge por order_id
-- inserta las órdenes nuevas y actualiza las que cambiaron de estado.
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = 'order_id',
        on_schema_change = 'sync_all_columns'
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
    {% if is_incremental() %}
        where loaded_at_utc > (select max(loaded_at_utc) from {{ this }})
    {% endif %}  
),

deduplicated as (
    select *
    from orders
    qualify row_number() over (partition by order_id order by loaded_at_utc desc) = 1
),

normalized as (
    select
        d.order_id
        , d.account_id
        , i.instrument_id
        , sd.side_id
        , d.quantity
        , d.execution_price
        , d.commission
        , st.status_id
        , d.ordered_at
        , d.loaded_at_utc
    from deduplicated d
    left join {{ ref('instruments') }} i
        on d.ticker = i.ticker
    left join {{ ref('order_sides') }} sd
        on d.side = sd.side_code
    left join {{ ref('order_statuses') }} st
        on d.status = st.status_code
)

select * from normalized


