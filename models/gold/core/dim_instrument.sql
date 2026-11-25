-- Dimensión de instrumentos
with instruments_cte as(
    select * from {{ ref('instruments') }}
),

sectors_cte as(
    select * from {{ ref('sectors') }}
),

asset_class as(
    select * from {{ ref('asset_classes') }}
),

currencies_cte as(
    select * from {{ ref('currencies') }}
),


dimension_instruments as(
    select
        i.instrument_id                 as instrument_key
        , i.ticker
        , i.instrument_name
        , s.sector_name                 as sector
        , a.asset_class
        , c.currency_name               as currency
        , a.asset_class = 'Benchmark'   as is_benchmark
    from instruments_cte i
    left join sectors_cte s
        on i.sector_id = s.sector_id
    left join asset_class a
        on i.asset_class_id = a.asset_class_id
    left join currencies_cte c
        on i.currency_code = c.currency_code
)

select * from dimension_instruments
