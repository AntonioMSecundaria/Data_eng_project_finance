-- Órdenes Grano: una orden.

with orders_cte as(
    select * from {{ ref('orders') }}
),

order_sides_cte as(
    select * from {{ ref('order_sides') }}
),

order_statuses_cte as(
    select * from {{ ref('order_statuses') }}
)

select
    o.order_id
    , to_char(o.ordered_at, 'YYYYMMDD'):: integer           as date_key
    , o.account_id                                          as portfolio_key
    , o.instrument_id                                       as instrument_key
    , s.side_name                                           as side
    , st.status_name                                        as order_status
    , o.quantity
    , o.execution_price
    , o.quantity * o.execution_price                        as gross_amount
    , o.commission
    , iff(st.is_executed, 1, 0)                             as is_filled
from orders_cte o
inner join order_sides_cte s
    on o.side_id = s.side_id
inner join order_statuses_cte st
    on o.status_id = st.status_id
