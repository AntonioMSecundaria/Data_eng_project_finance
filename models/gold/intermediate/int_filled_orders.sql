-- Órdenes que se han llevado a cabo
with orders_cte as(
    select * from {{ ref('orders') }}
),

order_sides_cte as(
    select * from {{ ref('order_sides') }}
),

order_statuses_cte as(
    select * from {{ ref('order_statuses') }}
),


calculated_filled_orders as(
    select
        o.order_id
        , o.account_id
        , o.instrument_id
        , o.ordered_at:: date          as trade_date
        , s.side_code
        , o.quantity
        , o.execution_price
        , o.commission
        -- Cantidad de dinero de cada orden con el signo, +compra, -venta
        , o.quantity * s.quantity_sign as signed_quantity
        -- Lo que se paga en cada orden de compra, el dinero que entra en la cartera + comisión, si es venta 0
        , case 
            when s.side_code = 'BUY' then o.quantity * o.execution_price + o.commission 
            else 0 
        end        as cash_in
        -- Lo que el cliente cobra en cada orden de compra, el dinero que sale de la cartera - comisión, si es compra 0
        , case 
            when s.side_code = 'SELL' then o.quantity * o.execution_price - o.commission 
            else 0 
        end         as cash_out
    from orders_cte o
    inner join order_sides_cte s
        on o.side_id = s.side_id
    inner join order_statuses_cte st
    on o.status_id = st.status_id
    where st.is_executed
)

select * from calculated_filled_orders