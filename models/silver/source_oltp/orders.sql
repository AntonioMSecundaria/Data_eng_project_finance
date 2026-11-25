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

select
    order_id
    , account_id
    , ticker
    , side
    , quantity
    , execution_price
    , commission
    , status as order_status
    , quantity * execution_price as gross_amount   -- NULL si la orden no se ejecutó
    , ordered_at
    , loaded_at_utc
from {{ ref('stg_orders') }}
{% if is_incremental() %}
where loaded_at_utc > (select max(loaded_at_utc) from {{ this }})
{% endif %}
qualify row_number() over (partition by order_id order by loaded_at_utc desc) = 1
