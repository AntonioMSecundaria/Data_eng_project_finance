-- Precio de cierre de cada instrumento en la última sesión de cada mes.
with daily_market_prices_cte as(
    select * from {{ ref('daily_market_prices') }}
),

month_date as(
    select
    price_date as month_end_date
    , instrument_id
    , close_price
from daily_market_prices_cte
qualify price_date = max(price_date) over (partition by instrument_id, date_trunc('month', price_date))
)

select * from month_date

