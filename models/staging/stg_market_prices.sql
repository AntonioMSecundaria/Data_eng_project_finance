with source as(
    select * from {{ source('source_oltp', 'tbl_market_prices') }}
)

select
    price_date
    , upper(trim(ticker))   as ticker
    , close_price
    , volume
    , source                as market_price_source
    , _loaded_at            as loaded_at_utc
from source