-- Estado actual de cada cuenta/cartera.
with last_update as(
    select
    p.account_id
    , p.client_code
    , p.account_name
    , i.instrument_id           as benchmark_instrument_id
    , p.created_at
    , p.updated_at_utc
from {{ ref('stg_parties_accounts') }} p
left join {{ref('instruments')}} i
    on p.benchmark_ticker = i.ticker
qualify row_number() over (partition by account_id order by updated_at_utc desc) = 1
)

select * from last_update

