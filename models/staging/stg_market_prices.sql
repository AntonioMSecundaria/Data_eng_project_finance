with source as(
    select * from {{ source('source_oltp', 'tbl_market_prices') }}
)

select
    price_date
    , upper(trim(ticker))   as ticker
    , close_price
    , volume
    , upper(trim(source))   as market_rpice_source
    , _loaded_at            as date_load
from source