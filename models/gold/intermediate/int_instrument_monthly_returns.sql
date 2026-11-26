-- Rentabilidad mensual de cada instrumento
with month_end_prices_cte as(
    select * from {{ ref('int_month_end_prices') }}
),

month_worth as(
    select
    month_end_date
    , instrument_id
    , close_price
    -- Calcula la proporción que cambia de un mes a otro
    , close_price / lag(close_price) over (partition by instrument_id order by month_end_date) - 1
        as monthly_return
from month_end_prices_cte
)

select * from month_worth

