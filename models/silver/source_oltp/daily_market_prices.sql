-- Precios de cierre de mercado 
-- Incremental

{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'microbatch',
        event_time = 'price_date',
        batch_size = 'month',
        begin = '2023-01-01',
        lookback = 1
    )
}}

with prices as (
    select * from {{ ref('stg_market_prices') }}
),

instruments_cte as(
    select * from {{ ref('instruments') }}
),

price_sources_cte as(
    select * from {{ ref('price_sources') }}
),

market_feed_priority as(
    select
    p.price_date
    , i.instrument_id
    , p.close_price
    , p.volume
    , s.price_source_id
    , p.loaded_at_utc
from prices p
inner join instruments_cte i
    on p.ticker = i.ticker
inner join price_sources_cte s
    on p.market_price_source = s.price_source
qualify row_number() over (
    partition by p.price_date, i.instrument_id
    order by s.priority, p.loaded_at_utc desc) =1
)

select * from market_feed_priority

