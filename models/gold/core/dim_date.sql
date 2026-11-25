-- Dimensión de fechas: un día por fila, con marca de sesión y de cierre de mes.
with calendar as (
    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "'2023-01-01':: date",
        end_date = "'2027-01-01'::date"
    ) }}
),

sessions as (
    select distinct price_date
    from {{ ref('daily_market_prices') }}
),

month_ends as (
    select distinct month_end_date
    from {{ ref('int_month_end_prices') }}
),

dimension_date as(
    select
        cast(to_char(c.date_day, 'YYYYMMDD') as integer)    as date_key
        , c.date_day:: date                                 as full_date
        , year(c.date_day)                                  as year
        , quarter(c.date_day)                               as quarter
        , month(c.date_day)                                 as month
        , year(c.date_day) * 100 + month(c.date_day)        as year_month
        , s.price_date is not null                          as is_trading_day
        , m.month_end_date is not null                      as is_month_end
    from calendar c
    left join sessions s
        on s.price_date = c.date_day::date
    left join month_ends m
        on m.month_end_date = c.date_day::date
)

select * from dimension_date
