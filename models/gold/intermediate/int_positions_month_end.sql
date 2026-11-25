-- Posición de cada cuenta en cada instrumento al cierre de cada mes.
-- Se suman todas las órdenes ejecutadas hasta ese día:

--   total_pnl    = valor actual + lo cobrado en ventas - lo pagado en compras

with month_ends as (
    select distinct month_end_date
    from {{ ref('int_month_end_prices') }}
),


accumulated as (
    select
        m.month_end_date
        , f.account_id
        , f.instrument_id
        , sum(f.signed_quantity)        as shares_held --Acciones compradas - vendidas
        , sum(f.cash_in)                as total_bought
        , sum(f.cash_out)               as total_sold
    from month_ends m
    inner join {{ ref('int_filled_orders') }} f
        on f.trade_date <= m.month_end_date            
    group by m.month_end_date, f.account_id, f.instrument_id
),

market_value_profit_loss as(
    select
    a.month_end_date
    , a.account_id
    , a.instrument_id
    , a.shares_held
    , a.total_bought
    , a.total_sold
    , p.close_price
    , a.shares_held * p.close_price                                 as market_value
    , a.shares_held * p.close_price + a.total_sold - a.total_bought as total_pnl
from accumulated a
inner join {{ ref('int_month_end_prices') }} p
    on p.month_end_date = a.month_end_date and p.instrument_id = a.instrument_id
)

select * from market_value_profit_loss

