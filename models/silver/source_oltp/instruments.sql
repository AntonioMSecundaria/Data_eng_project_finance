-- Silver: catálogo de instrumentos (3FN). Una fila por instrumento.
select
    instrument_id
    , ticker
    , instrument_name
    , sector
    , asset_class
    , currency
    , loaded_at_utc
from {{ ref('stg_instruments') }}
