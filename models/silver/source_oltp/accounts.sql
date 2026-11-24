-- Silver: estado actual de cada cuenta (última versión por account_id).
-- El historial de cambios de cliente irá en el snapshot.
select
    account_id
    , client_code
    , account_name
    , benchmark_ticker
    , opened_date
    , updated_at_utc
from {{ ref('stg_parties_account') }}
qualify row_number() over (partition by account_id order by updated_at_utc desc) = 1
