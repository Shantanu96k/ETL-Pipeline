from extract   import extract_data
from transform import transform_data, create_star_schema
from load      import load_to_mysql

def run_pipeline():
    raw        = extract_data()
    clean      = transform_data(raw)
    dims       = create_star_schema(clean)
    load_to_mysql(*dims)
    
if __name__ == "__main__":
    run_pipeline()