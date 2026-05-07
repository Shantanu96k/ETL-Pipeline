from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

load_dotenv()

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("DB_NAME")

engine = create_engine(
    f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

def load_to_mysql(dim_customers, dim_products, dim_geography, fact_orders):
    tables = {
        "dim_customers" : dim_customers,
        "dim_products"  : dim_products,
        "dim_geography" : dim_geography,
        "fact_orders"   : fact_orders
    }
    for name, df in tables.items():
        df.to_sql(name, engine, if_exists="replace", index=False)
        print(f"[LOAD] '{name}' → {len(df)} rows loaded")