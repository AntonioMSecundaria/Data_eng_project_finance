-- Estado actual de cada cuenta/cartera.
with versions as (
    select
        s.account_id
        , s.client_code
        , s.account_name
        , i.instrument_id       as benchmark_instrument_id
        , s.created_at          as opened_date
        , s.dbt_valid_from      as valid_from
        , hash(s.client_code, s.account_name, i.instrument_id, s.created_at) as attributes_hash
    from {{ ref('snap_parties_accounts') }} s
    left join {{ ref('instruments') }} i
        on s.benchmark_ticker = i.ticker
),

changes as (
    select
        *
        , lag(attributes_hash) over (partition by account_id order by valid_from) as previous_hash
    from versions
),

account_versions as (
    select
        account_id
        , client_code
        , account_name
        , benchmark_instrument_id
        , opened_date
        , valid_from
        , lead(valid_from) over (partition by account_id order by valid_from) as valid_to
    from changes
    where previous_hash is null
       or attributes_hash <> previous_hash
),

Vigencia as(
    select
    *
    , valid_to is null as is_current
from account_versions
)

select * from Vigencia

