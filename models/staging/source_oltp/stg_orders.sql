with source as(
    select * from {{ source('source_oltp', 'tbl_orders') }}
)

select
    order_id
    , account_id
    , upper(trim(ticker))               as ticker
    , side
    , quantity
    , execution_price
    , commission
    , status
    , order_timestamp                   as ordered_at
    , _loaded_at                        as loaded_at_utc
from source