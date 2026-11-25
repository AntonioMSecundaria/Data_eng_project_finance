-- Estado actual de cada cliente

with versions as (
    select
        client_code
        , full_name                     as client_name
        , country                       as country_name
        , risk_profile
        , dbt_valid_from                as valid_from
        , hash(full_name, risk_profile) as attributes_hash
    from {{ ref('snap_parties_accounts') }}
),

changes as (
    select
        *
        , lag(attributes_hash) over (partition by client_code order by valid_from) as previous_hash
    from versions
),

client_versions as (
    select
        client_code
        , client_name
        , country_name
        , risk_profile
        , valid_from
        , lead(valid_from) over (partition by client_code order by valid_from) as valid_to
    from changes
    where previous_hash is null
       or attributes_hash <> previous_hash
),

normalized as (
    select
        v.client_code
        , v.client_name
        , c.country_code
        , r.risk_profile_code
        , v.valid_from
        , v.valid_to
        , v.valid_to is null as is_current
    from client_versions v
    left join {{ ref('country_codes') }} c
        on v.country_name = c.country_name
    left join {{ ref('risk_profile') }} r
        on v.risk_profile = r.risk_profile
)



select * from normalized