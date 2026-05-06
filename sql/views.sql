USE superstore_etl;
CREATE OR REPLACE VIEW vw_monthly_kpi AS
SELECT
    order_year,
    order_month,
    order_quarter,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(cost),2) AS total_cost,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin,
    ROUND(AVG(ship_delay_days), 1) AS avg_ship_delay,
    SUM(loss_flag)  AS loss_orders_count
FROM fact_orders
GROUP BY order_year, order_month, order_quarter
ORDER BY order_year, order_month;


CREATE OR REPLACE VIEW vw_category_performance AS
SELECT
    p.category,
    p.sub_category,
    COUNT(f.order_id) AS total_orders,
    SUM(f.quantity) AS units_sold,
    ROUND(SUM(f.sales),2) AS total_sales,
    ROUND(SUM(f.profit),2) AS total_profit,
    ROUND(AVG(f.profit_margin), 2) AS avg_margin,
    SUM(f.loss_flag) AS loss_orders
FROM fact_orders f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY total_sales DESC;


CREATE OR REPLACE VIEW vw_region_performance AS
SELECT
    g.region,
    g.state,
    COUNT(f.order_id) AS total_orders,
    ROUND(SUM(f.sales),2) AS total_sales,
    ROUND(SUM(f.profit),2) AS total_profit,
    ROUND(AVG(f.profit_margin), 2) AS avg_margin,
    ROUND(AVG(f.ship_delay_days),1) AS avg_ship_delay
FROM fact_orders f
JOIN dim_geography g ON f.postal_code = g.postal_code
GROUP BY g.region, g.state
ORDER BY total_sales DESC;


CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    COUNT(f.order_id) AS total_orders,
    ROUND(SUM(f.sales),2) AS lifetime_value,
    ROUND(SUM(f.profit),2) AS total_profit,
    ROUND(AVG(f.discount), 3) AS avg_discount,
    MAX(f.order_date) AS last_order_date,
    SUM(f.loss_flag) AS loss_orders
FROM fact_orders f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY lifetime_value DESC;

CREATE  VIEW vw_discount_impact AS
SELECT
    CASE
        WHEN discount = 0 THEN '0% - No Discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE 'Above 30%'
    END AS discount_tier,
    COUNT(*) AS order_count,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(sales), 2) AS avg_order_value,
    SUM(loss_flag) AS loss_orders
FROM fact_orders
GROUP BY discount_tier
ORDER BY avg_profit_margin DESC;