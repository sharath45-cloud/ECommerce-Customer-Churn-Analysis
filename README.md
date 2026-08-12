# 🛒 E-Commerce Customer Churn & Analytics Pipeline

![Python](https://img.shields.io/badge/Python-3.12-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15.0-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-150458?style=for-the-badge&logo=pandas&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-ORM-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.style=for-the-badge)

An end-to-end Data Engineering and Business Analytics pipeline designed to clean, transform, ingest, and analyze e-commerce customer behavior data to understand and mitigate customer churn.

---

## 📌 Executive Summary

Customer churn is a critical metric in the e-commerce sector. This project establishes an automated **ETL (Extract, Transform, Load)** pipeline that processes raw customer transaction and behavioral datasets, cleans missing/skewed data using median imputation, ingests structured data into a relational **PostgreSQL** database, and executes targeted **SQL Analytics** to uncover key churn drivers.

---

## 🏗️ Architecture & Pipeline Workflow

`[ Raw Excel Data ] ➡️ [ Data Cleaning & Imputation (Pandas) ] ➡️ [ PostgreSQL Ingestion (SQLAlchemy) ] ➡️ [ Advanced Analytics (SQL Queries) ]`

1. **Extraction**: Ingest raw dataset from multi-sheet Excel files (`E Commerce Dataset`).
2. **Transformation**: Standardize column names to lowercase, clean string anomalies, and handle missing numeric attributes via median imputation.
3. **Loading**: Programmatically build schema and write clean datasets into PostgreSQL via SQLAlchemy engine.
4. **Analytics**: Run relational SQL queries in PostgreSQL / pgAdmin to calculate churn rates, complaint correlations, distance-to-home impact, and device metrics.

---

## 📊 Data Dictionary

| Column Name | Data Type | Null Values (Raw) | Handling Strategy / Description |
| :--- | :--- | :--- | :--- |
| `customerid` | Integer | 0 | Unique identifier for each customer |
| `churn` | Integer | 0 | Churn Indicator (`1` = Churned, `0` = Active) |
| `tenure` | Float/Int | 264 | Months customer stayed with the company (Imputed via Median) |
| `preferredlogindevice` | Varchar | 0 | Device used to login (`Phone`, `Mobile Phone`, `Computer`) |
| `citytier` | Integer | 0 | Tier of customer's city (`1`, `2`, `3`) |
| `warehousetohome` | Float | 251 | Distance between warehouse and customer home (Imputed via Median) |
| `preferredpaymentmode` | Varchar | 0 | Preferred mode of payment (`Debit Card`, `Credit Card`, `E wallet`, `UPI`, `COD`) |
| `gender` | Varchar | 0 | Customer Gender (`Male`, `Female`) |
| `hourspendonapp` | Float | 255 | Hours spent on app daily (Imputed via Median) |
| `numberofdeviceregistered` | Integer | 0 | Total devices registered under account |
| `preferedordercat` | Varchar | 0 | Main category ordered (`Laptop & Accessory`, `Mobile`, `Fashion`, `Grocery`, `Others`) |
| `satisfactionscore` | Integer | 0 | Customer satisfaction score (`1` to `5`) |
| `maritalstatus` | Varchar | 0 | Marital Status (`Single`, `Married`, `Divorced`) |
| `numberofaddress` | Integer | 0 | Total registered addresses |
| `complain` | Integer | 0 | Complaint raised in last month (`1` = Yes, `0` = No) |
| `orderamounthikefromlastyear` | Float | 265 | Percentage hike in order amount from last year (Imputed via Median) |
| `couponused` | Float | 256 | Number of coupons used (Imputed via Median) |
| `ordercount` | Float | 258 | Total count of orders placed (Imputed via Median) |
| `daysincelastorder` | Float | 307 | Days elapsed since last order (Imputed via Median) |
| `cashbackamount` | Float | 0 | Average cashback amount earned |

---

## 🧹 Data Preprocessing & Cleaning Strategy

Data preprocessing was performed using Python's `Pandas` library to ensure data integrity before database ingestion:

- **Missing Value Imputation**: Skewed numerical attributes (`tenure`, `warehousetohome`, `hourspendonapp`, `ordercount`, etc.) were imputed using **Median Imputation** to avoid bias caused by extreme outliers.
- **Categorical Imputation**: Any missing categorical strings were set to `'Unknown'`.
- **Column Standardization**: All column names were transformed into lowercase (`df.columns.str.lower()`) for seamless compatibility with PostgreSQL syntax.

---

## 📈 Key SQL Analytics & Queries

### 1. Overall Customer Churn Rate

```sql
SELECT 
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn)::NUMERIC / COUNT(*)) * 100, 2) AS churn_rate_percentage
FROM ecommerce_churn;
