-- Cierres de mercado. Grano: instrumento y cierre de mes.

with instrument_monthly_returns_cte as(
    select * from {{ ref('int_instrument_monthly_returns') }}
),

facts_instruments_monthly as(
    select
        to_char(month_end_date, 'YYYYMMDD')::integer    as date_key
        , instrument_id                                 as instrument_key
        , close_price
        , monthly_return
    from instrument_monthly_returns_cte
)

select * from facts_instruments_monthly


