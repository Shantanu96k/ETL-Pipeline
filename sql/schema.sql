CREATE DATABASE IF NOT EXISTS superstore_etl;
USE superstore_etl;

CREATE TABLE dim_customers (
    customer_id   VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment       VARCHAR(50)
);

CREATE TABLE dim_products (
    product_id   VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(200),
    category     VARCHAR(50),
    sub_category VARCHAR(50)
);

CREATE TABLE dim_geography (
    geo_id      SERIAL PRIMARY KEY,
    postal_code VARCHAR(20),
    city        VARCHAR(100),
    state       VARCHAR(100),
    region      VARCHAR(50),
    country     VARCHAR(50)
);

CREATE TABLE dim_date (
    date        DATE PRIMARY KEY,
    year        INT,
    month       INT,
    month_name  VARCHAR(20),
    quarter     INT,
    day_of_week INT,
    day_name    VARCHAR(20),
    is_weekend  BOOLEAN
);

CREATE TABLE fact_orders (
    order_id          VARCHAR(30),
    order_date        DATE REFERENCES dim_date(date),
    ship_date         DATE,
    ship_mode         VARCHAR(50),
    customer_id       VARCHAR(20) REFERENCES dim_customers(customer_id),
    product_id        VARCHAR(20) REFERENCES dim_products(product_id),
    postal_code       VARCHAR(20),
    sales             NUMERIC(10,2),
    quantity          INT,
    discount          NUMERIC(5,2),
    profit            NUMERIC(10,2),
    revenue           NUMERIC(10,2),
    cost              NUMERIC(10,2),
    profit_margin     NUMERIC(8,2),
    ship_delay_days   INT,
    high_discount_flag INT,
    order_year        INT,
    order_month       INT,
    order_quarter     INT,
    PRIMARY KEY (order_id, product_id)
);

CREATE INDEX idx_fact_orders_date     ON fact_orders(order_date);
CREATE INDEX idx_fact_orders_customer ON fact_orders(customer_id);
CREATE INDEX idx_fact_orders_product  ON fact_orders(product_id);
CREATE INDEX idx_fact_orders_region   ON fact_orders(postal_code);