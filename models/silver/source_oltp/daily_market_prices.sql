-- Precios de cierre de mercado 
-- Incremental

{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['price_date', 'instrument_id'],
        on_schema_change = 'append_new_columns'
    )
}}

with prices as (
    select * from {{ ref('stg_market_prices') }}
    {% if is_incremental() %}
    where price_date >= (select dateadd(day, -10, max(price_date)) from {{ this }})
    {% endif %}
)

with market_feed_priority(
    select
    p.price_date
    , i.instrument_id
    , i.ticker
    , p.close_price
    , p.volume
    , s.price_source_id
    , p.loaded_at_utc
from prices p
inner join {{ ref('instruments') }} i
    on p.ticker = i.ticker
inner join {{ ref('price_source') }} s
qualify row_number() over (
    partition by p.price_date, i.instrument_id
    order by s.priority, p.loaded_at_utc desc) =1
)

