with merchant_metrics as (
    select
        merchant,
        count() as transaction_count,
        sum(is_fraud) as fraud_count,
        100.0 * sum(is_fraud) / count() as fraud_rate,
        sum(amount) as total_amount,
        sumIf(amount, is_fraud = 1) as fraud_amount,
        uniqExact(customer_key) as unique_customers
    from
        {{ ref('stg_transactions') }}
    group by
        merchant
)

select
    *,
    toUInt8(
        fraud_rate >= {{ var('high_risk_rate') }}
        and transaction_count >= {{ var('suspicious_min_transactions') }}
    ) as is_suspicious
from
    merchant_metrics
