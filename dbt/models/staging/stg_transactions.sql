with normalized as (
    select
        toDateTime(transaction_time, 'UTC') as transaction_time,
        trimBoth(merch) as merchant,
        lowerUTF8(trimBoth(cat_id)) as category,
        toFloat64(amount) as amount,
        lowerUTF8(trimBoth(name_1)) as first_name,
        lowerUTF8(trimBoth(name_2)) as last_name,
        upperUTF8(trimBoth(gender)) as gender,
        upperUTF8(trimBoth(us_state)) as state,
        toFloat64(lat) as latitude,
        toFloat64(lon) as longitude,
        toFloat64(merchant_lat) as merchant_latitude,
        toFloat64(merchant_lon) as merchant_longitude,
        toUInt8(target) as is_fraud
    from
        {{ source('raw', 'transactions') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['first_name', 'last_name', 'gender', 'latitude', 'longitude']) }} as customer_key,
    transaction_time,
    toDate(transaction_time) as transaction_date,
    {{ dbt_date.day_of_week('transaction_time', isoweek=true) }} as day_of_week,
    toHour(transaction_time) as transaction_hour,
    merchant,
    category,
    amount,
    {{ amount_bucket('amount') }} as amount_bucket,
    gender,
    state,
    latitude,
    longitude,
    merchant_latitude,
    merchant_longitude,
    is_fraud
from
    normalized
