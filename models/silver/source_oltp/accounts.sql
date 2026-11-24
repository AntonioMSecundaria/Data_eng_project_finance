-- Estado actual de cada cuenta/cartera.
with last_update as(
    select
    account_id
    , client_code
    , account_name
    , benchmark_ticker
    , opened_date
    , updated_at_utc
from {{ ref('stg_parties_account') }}
qualify row_number() over (partition by account_id order by updated_at_utc desc) = 1
)

select * last_update

