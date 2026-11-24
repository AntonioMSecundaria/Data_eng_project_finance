-- Silver incremental: un precio por sesión e instrumento.
-- Si hay dos proveedores para la misma sesión, gana MARKET_FEED sobre BACKUP_FEED.
-- En cada ejecución se relee una ventana de 10 días hasta el último precio ya cargado,
-- para absorber precios tardíos o correcciones; el merge evita duplicados.
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['price_date', 'instrument_id'],
        on_schema_change = 'sync_all_columns'
    )
}}

with prices as (
    select *
    from {{ ref('stg_market_prices') }}
    {% if is_incremental() %}
    where price_date >= (select dateadd(day, -10, max(price_date)) from {{ this }})
    {% endif %}
)

select
    p.price_date
    , i.instrument_id
    , p.ticker
    , p.close_price
    , p.volume
    , p.market_price_source
    , p.loaded_at_utc
from prices p
inner join {{ ref('instruments') }} i
    on p.ticker = i.ticker
qualify row_number() over (
    partition by p.price_date, i.instrument_id
    order by iff(p.market_price_source = 'MARKET_FEED', 0, 1), p.loaded_at_utc desc
) = 1
