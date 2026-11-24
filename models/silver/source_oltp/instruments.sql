-- Instrumentos busátiles

with normalized as(
    select
        i.instrument_id
        , i.ticker
        , i.instrument_name
        , s.sector_id
        , a.asset_class_id
        , c.currency_code
        , i.loaded_at_utc
    from {{ ref('stg_instruments') }} i
    left join {{ ref('sectors') }} s
        on i.sector = s.sector_name
    left join {{ ref('asset_classes') }} a
        on i.asset_class = a.asset_class
    left join {{ ref('currencies') }} c
        on i.currency = c.currency_code
)

select * normalized