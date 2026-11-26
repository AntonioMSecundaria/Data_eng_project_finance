-- Instrumentos busátiles

with stg_instruments_cte as(
    select * from {{ ref('stg_instruments') }}
),

sectors_cte as(
    select * from {{ ref('sectors') }}
),

asset_classes_cte as(
    select * from {{ ref('asset_classes') }}
),

currencies as(
    select * from {{ ref('currencies') }}
),

normalized as(
    select
        i.instrument_id
        , i.ticker
        , i.instrument_name
        , s.sector_id
        , a.asset_class_id
        , c.currency_code
        , i.loaded_at_utc
    from stg_instruments_cte i
    left join sectors_cte s
        on i.sector = s.sector_name
    left join asset_classes_cte a
        on i.asset_class = a.asset_class
    left join currencies c
        on i.currency = c.currency_code
)

select * from normalized