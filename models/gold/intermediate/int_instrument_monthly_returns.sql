-- Rentabilidad mensual de cada instrumento

with month_worth as(
    select
    month_end_date
    , instrument_id
    , close_price
    -- Calcula la proporción que cambia de un mes a otro
    , close_price / lag(close_price) over (partition by instrument_id order by month_end_date) - 1
        as monthly_return
from {{ ref('int_month_end_prices') }}
)

select * from month_worth

