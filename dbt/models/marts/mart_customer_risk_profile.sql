with customer_metrics as (
    select
        customer_key,
        count() as transaction_count,
        sum(is_fraud) as fraud_count,
        100.0 * sum(is_fraud) / count() as fraud_rate,
        sum(amount) as total_amount,
        avg(amount) as avg_amount,
        min(transaction_time) as first_transaction_time,
        max(transaction_time) as last_transaction_time
    from
        {{ ref('stg_transactions') }}
    group by
        customer_key
)
select
    *,
    {{ risk_level('fraud_rate') }} as risk_level
from
    customer_metrics
