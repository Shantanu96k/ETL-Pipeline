from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:Shantanu%401234@127.0.0.1:3306/superstore_etl"
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