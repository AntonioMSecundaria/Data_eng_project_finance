with source as(
    select * from {{ source('source_oltp', 'tbl_instruments') }}
)

select
    instrument_id
    , ticker
    , instrument_name
    , sector
    , asset_class
    , currency
    , _loaded_at as loaded_at           as date_load
from source