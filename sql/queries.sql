USE superstore_etl;

-- QUERY 1: Running Total Revenue (Window Function)
SELECT
    order_date,
    SUM(sales) AS daily_sales,
    SUM(SUM(sales)) OVER (ORDER BY order_date)  AS cumulative_sales,
    SUM(profit) AS daily_profit,
    SUM(SUM(profit)) OVER (ORDER BY order_date) AS cumulative_profit
FROM fact_orders
GROUP BY order_date
ORDER BY order_date;


-- QUERY 2: Month-over-Month Growth Rate (CTE + LAG)

WITH monthly AS (
    SELECT
        order_year,
        order_month,
        SUM(sales)  AS monthly_sales,
        SUM(profit) AS monthly_profit
    FROM fact_orders
    GROUP BY order_year, order_month
),
growth AS (
    SELECT
        order_year,
        order_month,
        monthly_sales,
        monthly_profit,
        LAG(monthly_sales)  OVER (ORDER BY order_year, order_month) AS prev_sales,
        LAG(monthly_profit) OVER (ORDER BY order_year, order_month) AS prev_profit
    FROM monthly
)
SELECT
    order_year,
    order_month,
    monthly_sales,
    prev_sales,
    ROUND(
        (monthly_sales - prev_sales) / NULLIF(prev_sales, 0) * 100, 2
    ) AS mom_sales_growth_pct,
    ROUND(
        (monthly_profit - prev_profit) / NULLIF(prev_profit, 0) * 100, 2
    ) AS mom_profit_growth_pct
FROM growth
ORDER BY order_year, order_month;



-- QUERY 3: Customer RFM Segmentation (NTILE)

WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF(CURDATE(), MAX(order_date))   AS recency_days,
        COUNT(DISTINCT order_id)               AS frequency,
        ROUND(SUM(sales), 2)                   AS monetary
    FROM fact_orders
    GROUP BY customer_id
),
rfm_scored AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC)  AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT
    r.customer_id,
    c.customer_name,
    c.segment,
    r.recency_days,
    r.frequency,
    r.monetary,
    r.r_score,
    r.f_score,
    r.m_score,
    (r.r_score + r.f_score + r.m_score) AS rfm_total,
    CASE
        WHEN (r.r_score + r.f_score + r.m_score) >= 13 THEN 'Champion'
        WHEN (r.r_score + r.f_score + r.m_score) >= 10 THEN 'Loyal Customer'
        WHEN (r.r_score + r.f_score + r.m_score) >= 7  THEN 'At Risk'
        ELSE 'Lost Customer'
    END AS customer_tier
FROM rfm_scored r
JOIN dim_customers c ON r.customer_id = c.customer_id
ORDER BY rfm_total DESC;



-- QUERY 4: Product Profitability Rank within Category (RANK)

SELECT
    p.category,
    p.sub_category,
    p.product_name,
    SUM(f.quantity) AS units_sold,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(AVG(f.profit_margin), 2) AS avg_margin,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(f.profit) DESC
    ) AS profit_rank_in_category
FROM fact_orders f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.category, p.sub_category, p.product_name
ORDER BY p.category, profit_rank_in_category;

-- QUERY 5: Pareto Analysis — 80/20 Rule on Products

WITH product_sales AS (
    SELECT
        p.product_name,
        p.category,
        ROUND(SUM(f.sales), 2) AS total_sales
    FROM fact_orders f
    JOIN dim_products p ON f.product_id = p.product_id
    GROUP BY p.product_name, p.category
),
pareto AS (
    SELECT
        product_name,
        category,
        total_sales,
        SUM(total_sales) OVER () AS grand_total,
        SUM(total_sales) OVER (ORDER BY total_sales DESC) AS running_total,
        ROUND(SUM(total_sales) OVER (ORDER BY total_sales DESC)/ SUM(total_sales) OVER () * 100, 2) AS cumulative_pct
    FROM product_sales
)
SELECT
    product_name,
    category,
    total_sales,
    cumulative_pct,
    CASE
        WHEN cumulative_pct <= 80 THEN 'Top 80% Revenue'
        ELSE 'Bottom 20% Revenue'
    END AS pareto_group
FROM pareto
ORDER BY total_sales DESC;


-- QUERY 6: Shipping Delay Analysis by Ship Mode

SELECT
    ship_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(ship_delay_days), 1) AS avg_delay_days,
    MIN(ship_delay_days) AS min_delay,
    MAX(ship_delay_days) AS max_delay,
    SUM(CASE WHEN ship_delay_days > 5 THEN 1 ELSE 0 END) AS delayed_orders,
    ROUND(SUM(CASE WHEN ship_delay_days > 5 THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS delay_rate_pct
FROM fact_orders
GROUP BY ship_mode
ORDER BY avg_delay_days;


-- QUERY 7: Year-over-Year Comparison (CTE + self-join logic)

SELECT
    order_month,
    ROUND(SUM(CASE WHEN order_year = 2015 THEN sales ELSE 0 END), 2) AS sales_2015,
    ROUND(SUM(CASE WHEN order_year = 2016 THEN sales ELSE 0 END), 2) AS sales_2016,
    ROUND(SUM(CASE WHEN order_year = 2017 THEN sales ELSE 0 END), 2) AS sales_2017
FROM fact_orders
GROUP BY order_month
ORDER BY order_month;


-- QUERY 8: Loss-Making Orders Deep Dive

SELECT
    c.segment,
    p.category,
    COUNT(*) AS loss_orders,
    ROUND(SUM(f.profit), 2) AS total_loss,
    ROUND(AVG(f.discount), 3) AS avg_discount,
    ROUND(AVG(f.profit_margin), 2) AS avg_margin
FROM fact_orders f
JOIN dim_customers c ON f.customer_id = c.customer_id
JOIN dim_products  p ON f.product_id  = p.product_id
WHERE f.loss_flag = 1
GROUP BY c.segment, p.category
ORDER BY total_loss ASC;