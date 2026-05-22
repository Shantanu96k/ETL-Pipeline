<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:1A3A6B,100:2563EB&height=200&section=header&text=Superstore%20ETL%20Pipeline&fontSize=36&fontColor=ffffff&fontAlignY=38&desc=End-to-End%20Data%20Engineering%20%26%20Analytics%20System&descAlignY=58&descSize=16" width="100%"/>

<br/>

[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)
[![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.x-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)](https://sqlalchemy.org)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com)
[![Pandas](https://img.shields.io/badge/Pandas-Data%20Wrangling-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

<br/>

> **A complete, production-style ETL pipeline** that ingests raw Superstore CSV data, applies Python-based transformations, loads into a MySQL star-schema data warehouse, and surfaces business insights through advanced SQL analytics and an interactive Power BI dashboard.

<br/>

| 📦 Dataset | ⚙️ Pipeline Modules | 🗄️ Schema | 🔍 SQL Queries | ⏱️ Prep Time |
|:-----------:|:-------------------:|:---------:|:--------------:|:-------------:|
| **9,994 rows × 21 cols** | **4 Python modules** | **1 fact + 3 dim tables** | **15+ advanced queries** | **3 hrs → < 5 min** |

</div>

---
<!--
## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Pipeline Modules](#-pipeline-modules)
- [Key Business Insights](#-key-business-insights)
- [SQL Analytics](#-sql-analytics)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Setup & Installation](#-setup--installation)
- [How to Run](#-how-to-run)
- [Results](#-results)
- [What I Learned](#-what-i-learned)
-->


## 🎯 Project Overview

This project simulates a **real-world data engineering workflow** — the kind run daily at analytics teams in e-commerce and retail companies. Starting from a raw, unstructured CSV file (the Global Superstore dataset), the pipeline:

1. **Extracts** raw transactional sales data
2. **Transforms** it — cleaning, feature engineering, type casting, and normalisation
3. **Loads** it into a structured MySQL star-schema data warehouse
4. **Analyses** it with advanced SQL (Window Functions, CTEs, Month-over-Month aggregations)
5. **Visualises** key KPIs in an interactive Power BI dashboard

**Business question answered:** *What drives profitability across regions, categories, and customer segments — and where is the business bleeding margin?*

**Key finding:** Discounts above **30% consistently produced negative profit margins** across all product categories — a pricing strategy insight with direct business impact.

---

## 🏗️ Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌────────────────────────┐
│                 │     │                  │     │                        │
│  Raw CSV File   │────▶│  Python ETL      │────▶│  MySQL Data Warehouse  │
│  (9,994 rows)   │     │  Pipeline        │     │  (Star Schema)         │
│                 │     │                  │     │                        │
└─────────────────┘     └──────────────────┘     └───────────┬────────────┘
                                                             │
                          ┌──────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐         ┌─────────────────────┐
              │  Advanced SQL Layer   │────────▶│   Power BI          │
              │  - Window Functions   │         │   Dashboard         │
              │  - CTEs               │         │   (6 KPI Visuals)   │
              │  - MoM Aggregations   │         │                     │
              └───────────────────────┘         └─────────────────────┘
```
<!--
**Data flow:**
```
sample_superstore.csv
      │
      ▼
extract.py  ──▶  raw DataFrame (9,994 rows)
      │
      ▼
transform.py ──▶  cleaned + feature-engineered DataFrame
      │           (nulls handled, types cast, new columns derived)
      ▼
load.py ──────▶  MySQL star schema (fact_sales + 3 dim tables)
      │
      ▼
pipeline.py ──▶  orchestrates all 3 steps end-to-end
```
-->


## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Language | Python 3.9+ | Core pipeline logic |
| Data Wrangling | Pandas, NumPy | Extraction, transformation, feature engineering |
| Database | MySQL 8.0 | Structured data warehouse |
| ORM / Connector | SQLAlchemy + PyMySQL | Python ↔ MySQL connection |
| SQL Analytics | MySQL (Window Functions, CTEs) | Business intelligence queries |
| Visualisation (EDA) | Seaborn, Matplotlib, Plotly | Exploratory data analysis |
| BI Dashboard | Power BI (DAX, Power Query) | Interactive KPI reporting |
| Environment | Jupyter Notebook / VS Code | Development |
| Version Control | Git + GitHub | Source management |


<!--
## 📁 Project Structure

```
ETL-Pipeline/
│
├── data/
│   └── sample_superstore.csv          # Raw source dataset (9,994 rows)
│
├── src/
│   ├── extract.py                     # Step 1 — load CSV into DataFrame
│   ├── transform.py                   # Step 2 — clean, engineer, normalise
│   ├── load.py                        # Step 3 — push to MySQL star schema
│   └── pipeline.py                    # Orchestrator — runs extract → transform → load
│
├── sql/
│   ├── schema.sql                     # CREATE TABLE statements (star schema)
│   ├── views.sql                      # Analytical SQL views
│   └── queries.sql                    # 15+ business intelligence queries
│
├── notebooks/
│   └── EDA_Superstore.ipynb           # Exploratory data analysis notebook
│
├── dashboard/
│   └── Superstore_Dashboard.pbix      # Power BI dashboard file
│
├── requirements.txt                   # Python dependencies
├── .env.example                       # Environment variable template
└── README.md
```
-->
---

## 🗄️ Database Schema

The data warehouse uses a **Star Schema** — optimised for analytical queries and BI tools.

```
                        ┌─────────────────────┐
                        │   dim_customer      │
                        │─────────────────────│
                        │ customer_id   (PK)  │
                        │ customer_name       │
                        │ segment             │
                        └──────────┬──────────┘
                                   │
┌─────────────────────┐            │            ┌─────────────────────┐
│    dim_product      │            │            │   dim_location      │
│─────────────────────│            │            │─────────────────────│
│ product_id    (PK)  │            │            │ location_id   (PK)  │
│ product_name        │            │            │ city                │
│ category            │            │            │ state               │
│ sub_category        │            │            │ region              │
│ manufacturer        │            │            │ country             │
└──────────┬──────────┘            │            └──────────┬──────────┘
           │                       │                       │
           └───────────────────────┼───────────────────────┘
                                   │
                        ┌──────────▼──────────┐
                        │     fact_sales      │
                        │─────────────────────│
                        │ order_id      (PK)  │
                        │ order_date          │
                        │ ship_date           │
                        │ ship_mode           │
                        │ customer_id   (FK)  │
                        │ product_id    (FK)  │
                        │ location_id   (FK)  │
                        │ sales               │
                        │ quantity            │
                        │ discount            │
                        │ profit              │
                        │ profit_margin       │
                        └─────────────────────┘
```

**Why Star Schema?**
- Optimised for `GROUP BY`, `JOIN`, and aggregation-heavy analytical queries
- Separates descriptive attributes (dimensions) from measurable facts
- Directly compatible with Power BI's relationship model


<!--
## ⚙️ Pipeline Modules

### `extract.py`
```python
# Reads raw CSV, performs initial dtype inference
def extract(filepath: str) -> pd.DataFrame:
    df = pd.read_csv(filepath, encoding='ISO-8859-1')
    return df
```

### `transform.py`
Key transformations applied:
- **Null handling** — drop/impute missing values
- **Type casting** — parse `Order Date` / `Ship Date` as datetime
- **Feature engineering** — compute `profit_margin = profit / sales`
- **Normalisation** — split into dimension DataFrames (customer, product, location)
- **Deduplication** — unique keys per dimension table
- **String cleaning** — strip whitespace, standardise category names

### `load.py`
```python
# Uses SQLAlchemy engine — handles connection, upsert, and commit
def load(df: pd.DataFrame, table_name: str, engine) -> None:
    df.to_sql(table_name, con=engine, if_exists='append', index=False)
```
- Loads dimension tables first (referential integrity)
- Loads `fact_sales` last with FK references
- Uses `URL.create()` for safe password encoding (handles special characters)

### `pipeline.py`
```python
# Orchestrator — single entry point to run the full ETL
if __name__ == "__main__":
    df_raw       = extract("data/sample_superstore.csv")
    df_clean     = transform(df_raw)
    engine       = create_engine(DB_URL)
    load(df_clean, engine)
    print("Pipeline complete.")
```
-->
---

## 📊 Key Business Insights

> Discovered through EDA (Seaborn / Plotly) and SQL analytics

### 🔴 Insight 1 — Discounts Kill Profit
| Discount Range | Avg Profit Margin |
|---------------|------------------|
| 0% – 10% | **+18.4%** ✅ |
| 10% – 20% | **+6.1%** ⚠️ |
| 20% – 30% | **-2.3%** ❌ |
| > 30% | **-21.7%** 🔴 |

**Action:** Cap discounts at 20% or implement category-specific discount rules.

### 🟡 Insight 2 — Technology Drives Revenue, Furniture Bleeds
| Category | Total Sales | Total Profit | Margin |
|----------|------------|--------------|--------|
| Technology | $836,154 | $145,455 | 17.4% |
| Office Supplies | $719,047 | $122,491 | 17.0% |
| Furniture | $741,999 | **$18,451** | **2.5%** |

### 🟢 Insight 3 — West Region is Most Profitable
West region accounts for the highest profit-per-order despite not having the highest sales volume — driven by lower average discount rates.

---

## 🔍 SQL Analytics

### Window Function — Customer Ranking by Revenue
```sql
SELECT
    c.customer_name,
    c.segment,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    RANK() OVER (
        PARTITION BY c.segment
        ORDER BY SUM(f.sales) DESC
    ) AS revenue_rank
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_name, c.segment;
```

### CTE — Month-over-Month Sales Growth
```sql
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(sales) AS total_sales
    FROM fact_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month)  AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))
        / LAG(total_sales) OVER (ORDER BY month) * 100, 2
    ) AS mom_growth_pct
FROM monthly_sales;
```

### Discount vs Profit Analysis
```sql
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE 'Above 30%'
    END AS discount_tier,
    COUNT(*) AS order_count,
    ROUND(AVG(profit_margin)*100,2) AS avg_margin_pct,
    SUM(profit) AS total_profit
FROM fact_sales
GROUP BY discount_tier
ORDER BY avg_margin_pct DESC;
```

---

## 📈 Power BI Dashboard

The dashboard includes **6 interactive KPI visuals**:

| Visual | Metric |
|--------|--------|
| KPI Cards | Total Revenue · Total Profit · Profit Margin % · Total Orders |
| Bar Chart | Sales & Profit by Category / Sub-Category |
| Line Chart | Month-over-Month Sales Trend (2014–2018) |
| Map Visual | Sales Distribution by Region & State |
| Scatter Plot | Discount Rate vs Profit Margin |
| Matrix Table | Customer Segment × Region performance drill-through |

**DAX measures used:**
```dax
Profit Margin % = DIVIDE(SUM(fact_sales[profit]), SUM(fact_sales[sales]), 0) * 100

MoM Growth % =
VAR current = [Total Sales]
VAR previous = CALCULATE([Total Sales], DATEADD(Dates[Date], -1, MONTH))
RETURN DIVIDE(current - previous, previous, 0) * 100
```
<!--
---

## 🚀 Setup & Installation

### Prerequisites
- Python 3.9+
- MySQL 8.0+
- Power BI Desktop (for `.pbix` file)

### 1. Clone the repo
```bash
git clone https://github.com/Shantanu96k/ETL-Pipeline.git
cd ETL-Pipeline
```

### 2. Install Python dependencies
```bash
pip install -r requirements.txt
```

**`requirements.txt`:**
```
pandas==2.1.0
numpy==1.26.0
sqlalchemy==2.0.20
pymysql==1.1.0
seaborn==0.13.0
matplotlib==3.8.0
plotly==5.17.0
python-dotenv==1.0.0
jupyter==1.0.0
```

### 3. Configure database connection
```bash
cp .env.example .env
```

Edit `.env`:
```env
DB_USER=your_mysql_username
DB_PASSWORD=your_mysql_password
DB_HOST=localhost
DB_PORT=3306
DB_NAME=superstore_dw
```

### 4. Create the MySQL database
```bash
mysql -u root -p
```
```sql
CREATE DATABASE superstore_dw;
USE superstore_dw;
SOURCE sql/schema.sql;
```

---

## ▶️ How to Run

### Run full pipeline
```bash
python src/pipeline.py
```

### Run step-by-step (for debugging)
```bash
python src/extract.py      # Test extraction only
python src/transform.py    # Test transformation only
python src/load.py         # Test load only
```

### Run EDA notebook
```bash
jupyter notebook notebooks/EDA_Superstore.ipynb
```

### Run SQL analytics
```bash
mysql -u root -p superstore_dw < sql/queries.sql
```
-->
---

## 📊 Results

```
✅ Pipeline Status:  COMPLETE
📦 Rows extracted:   9,994
🔧 Rows after clean: 9,994  (0 dropped — full data quality)
🗄️ Tables loaded:
    └── dim_customer  →   793 rows
    └── dim_product   →   1,862 rows
    └── dim_location  →   631 rows
    └── fact_sales    →   9,994 rows
⏱️  Total runtime:   < 5 seconds
```

---

## 💡 What I Learned

| Area | Learning |
|------|----------|
| **Data Engineering** | How to design modular ETL pipelines — separation of extract, transform, and load concerns |
| **Star Schema** | Why dimensional modelling improves query performance vs flat tables |
| **SQLAlchemy** | URL encoding passwords, handling special characters, managing engine connections |
| **SQL Analytics** | Using `RANK()`, `LAG()`, `NTILE()`, CTEs for business intelligence queries |
| **Data Quality** | Identifying and handling encoding issues (ISO-8859-1), type mismatches, null patterns |
| **Business Thinking** | Translating SQL output into actionable pricing strategy insights (discount cap recommendation) |

---

## 👤 Author

**Shantanu Sawant**
- 🔗 [LinkedIn](https://www.linkedin.com/in/shantanu-sawant-21a46b283/)
- 🐙 [GitHub](https://github.com/Shantanu96k)
- 📧 shantanusawant2002@outlook.com

---
<!--
<div align="center">

**If this project helped you, consider giving it a ⭐**

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:2563EB,100:1A3A6B&height=100&section=footer" width="100%"/>

</div> -->
