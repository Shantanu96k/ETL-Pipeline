import pandas as pd

def extract_data():
    df = pd.read_csv(r"E:\ETL Project\data\raw\Sample - Superstore.csv", encoding="latin-1")
    return df