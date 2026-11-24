with source as(
    select *from {{ source('source_oltp', 'tbl_parties_accounts') }}
)

select
    client_code
    , full_name
    , country
    , risk_profile
    , account_id
    , account_name
    , upper(trim(benchmark_ticker))     as benchmark_ticker
    , opened_date                       as created_at
    , updated_at                        as updated_at_utc
    , _loaded_at                        as loaded_at_utc
from source