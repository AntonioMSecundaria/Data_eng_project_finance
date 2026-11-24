-- Silver: estado actual de cada cliente (última versión por client_code), en 3FN:
-- el país y el perfil de riesgo se resuelven contra las seeds.
select
    s.client_code
    , s.full_name as client_name
    , c.country_code
    , r.risk_profile_code
    , s.updated_at_utc
from (
    select *
    from {{ ref('stg_parties_account') }}
    qualify row_number() over (partition by client_code order by updated_at_utc desc) = 1
) s
left join {{ ref('country_codes') }} c
    on s.country = c.country_name
left join {{ ref('risk_profile') }} r
    on s.risk_profile = r.risk_profile
