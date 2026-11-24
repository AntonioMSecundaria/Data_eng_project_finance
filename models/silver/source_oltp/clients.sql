-- Estado actual de cada cliente

with parties_accounts as(
    select 
        client_code
        , full_name
        , updated_at_utc
    from {{ ref('stg_parties_accounts') }}
    qualify row_number() over (partition by client_code order by updated_at_utc desc
),

with normalized as(
    select
    s.client_code
    , s.full_name as client_name
    , c.country_code
    , r.risk_profile_code
    , s.updated_at_utc
from parties_accounts s
left join {{ ref('country_codes') }} c
    on s.country = c.country_name
left join {{ ref('risk_profile') }} r
    on s.risk_profile = r.risk_profile
)

select * normalized


