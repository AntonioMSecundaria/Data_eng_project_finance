-- Dimensión de carteras Grano: cuenta y los datos actuales de su cliente asociado.
with current_clients as(
    select *
    from {{ ref('clients') }}
    where is_current
),

accounts_cte as(
    select * from {{ ref('accounts') }}
),

country_codes_cte as(
    select * from {{ ref('country_codes') }}
),

risk_profile_cte as(
    select * from {{ ref('risk_profile') }}
),

dimension_portfolio as(
    select
    a.account_id                    as portfolio_key
    , a.account_name
    , a.opened_date
    , a.client_code
    , c.client_name
    , cc.country_name               as country
    , cc.continent
    , r.risk_profile
from accounts_cte a
inner join current_clients c
    on a.client_code = c.client_code
left join country_codes_cte cc
    on c.country_code = cc.country_code
left join risk_profile_cte r
    on c.risk_profile_code = r.risk_profile_code
where a.is_current --Estado actual de la cartera
)

select * from dimension_portfolio