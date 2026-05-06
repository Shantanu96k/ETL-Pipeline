import pandas as pd
import numpy as np

def clean_columns(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace("-", "_")
    )
    return df

def parse_dates(df):
    df["order_date"] = pd.to_datetime(df["order_date"])
    df["ship_date"]  = pd.to_datetime(df["ship_date"])
    return df

def engineer_features(df):
    df["order_year"]     = df["order_date"].dt.year
    df["order_month"]    = df["order_date"].dt.month
    df["order_quarter"]  = df["order_date"].dt.quarter
    df["ship_delay_days"] = (df["ship_date"] - df["order_date"]).dt.days
    df["profit_margin"]   = (df["profit"] / df["sales"].replace(0, np.nan) * 100).round(2)
    df["cost"]            = df["sales"] - df["profit"]
    df["loss_flag"]       = (df["profit"] < 0).astype(int)
    return df

def handle_quality(df):
    before = len(df)
    df["postal_code"] = df["postal_code"].fillna("UNKNOWN")
    df = df.dropna(subset=["sales", "profit"])
    print(f"[TRANSFORM] Removed {before - len(df)} bad rows")
    return df

def transform_data(df):
    df = clean_columns(df)
    df = parse_dates(df)
    df = engineer_features(df)
    df = handle_quality(df)
    df.to_csv("data/processed/clean_superstore.csv", index=False)
    print(f"[TRANSFORM] Final shape: {df.shape}")
    return df
def create_star_schema(df):

    dim_customers = (df[["customer_id", "customer_name", "segment"]])
    dim_products = (df[["product_id", "product_name","category", "sub_category"]])
    dim_geography = (df[["postal_code", "city", "state", "region"]])
    fact_orders = df[[
        "order_id", "order_date", "ship_date", "ship_mode",
        "customer_id", "product_id", "postal_code",
        "sales", "quantity", "discount", "profit",
        "cost", "profit_margin", "ship_delay_days", "loss_flag",
        "order_year", "order_month", "order_quarter"
    ]]
    return dim_customers, dim_products, dim_geography, fact_orders