with source as(
    select * from {{ source('source_oltp', 'tbl_instruments') }}
)

select
    instrument_id
    , upper(trim(ticker))               as ticker
    , instrument_name
    , sector
    , asset_class
    , currency
    , _loaded_at                        as loaded_at_utc
from source