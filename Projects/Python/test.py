import pandas as pd
from sqlalchemy import create_engine
engine = create_engine(
    'postgresql+psycopg2://postgres:Hh010898@@@localhost:5432/stackoverflow')

with engine.connect() as psql_conn:
    df1 = pd.read_sql_query(
        'select * from users limit 100', psql_conn)
