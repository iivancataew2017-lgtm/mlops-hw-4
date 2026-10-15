import os
import sys

import clickhouse_connect
import pandas as pd

client = clickhouse_connect.get_client(
    host=os.getenv('DBT_HOST', '127.0.0.1'),
    port=int(os.getenv('DBT_PORT', '18123')),
    username=os.getenv('DBT_USER', 'dbt'),
    password=os.getenv('DBT_ENV_SECRET_PASSWORD', 'dbt_local'),
)

columns = [
    'transaction_time', 'merch', 'cat_id', 'amount', 'name_1', 'name_2',
    'gender', 'us_state', 'lat', 'lon', 'merchant_lat', 'merchant_lon', 'target',
]

for data in pd.read_csv(sys.argv[1], chunksize=25000):
    data = data[columns]
    data['transaction_time'] = pd.to_datetime(data['transaction_time'], utc=True)
    client.insert_df('transactions_db.transactions', data)
