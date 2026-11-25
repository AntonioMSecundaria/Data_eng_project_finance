-- Hechos de posiciones. Grano: cartera, instrumento y cierre de mes.

with positions_month_end_cte as(
    select * from {{ ref('int_positions_month_end') }}
),

facts_positions_monthly as(
    select
        to_char(month_end_date, 'YYYYMMDD')::integer    as date_key
        , account_id                                    as portfolio_key
        , instrument_id                                 as instrument_key
        , shares_held
        , close_price
        , market_value
        , total_bought
        , total_sold
        , total_pnl
    from positions_month_end_cte
)

select * from facts_positions_monthly

