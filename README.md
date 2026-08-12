# 🛒 E-Commerce Customer Churn & Analytics Pipeline

An end-to-end Data Engineering and Business Analytics pipeline designed to clean, transform, ingest, and analyze e-commerce customer behavior data to understand and mitigate customer churn.

---

## 📌 Executive Summary

Customer churn is a critical metric in the e-commerce sector. This project establishes an automated ETL (Extract, Transform, Load) pipeline that processes raw customer transaction and behavioral datasets, cleans missing/skewed data using median imputation, ingests structured data into a relational PostgreSQL database, and executes targeted SQL Analytics to uncover key churn drivers.

---

## 🏗️ Architecture & Pipeline Workflow

[ Raw Excel Data ] -> [ Data Cleaning & Imputation (Pandas) ] -> [ PostgreSQL Ingestion (SQLAlchemy) ] -> [ Advanced Analytics (SQL Queries) ]

1. Extraction: Ingest raw dataset from multi-sheet Excel files (E Commerce Dataset).
2. Transformation: Standardize column names to lowercase, clean string anomalies, and handle missing numeric attributes via median imputation.
3. Loading: Programmatically build schema and write clean datasets into PostgreSQL via SQLAlchemy engine.
4. Analytics: Run relational SQL queries in PostgreSQL / pgAdmin to calculate churn rates, complaint correlations, distance-to-home impact, and device metrics.

---

## 📊 Data Dictionary

| Column Name | Data Type | Null Values (Raw) | Handling Strategy / Description |
| :--- | :--- | :--- | :--- |
| customerid | Integer | 0 | Unique identifier for each customer |
| churn | Integer | 0 | Churn Indicator (1 = Churned, 0 = Active) |
| tenure | Float/Int | 264 | Months customer stayed with the company (Imputed via Median) |
| preferredlogindevice | Varchar | 0 | Device used to login (Phone, Mobile Phone, Computer) |
| citytier | Integer | 0 | Tier of customer's city (1, 2, 3) |
| warehousetohome | Float | 251 | Distance between warehouse and customer home (Imputed via Median) |
| preferredpaymentmode | Varchar | 0 | Preferred mode of payment (Debit Card, Credit Card, E wallet, UPI, COD) |
| gender | Varchar | 0 | Customer Gender (Male, Female) |
| hourspendonapp | Float | 255 | Hours spent on app daily (Imputed via Median) |
| numberofdeviceregistered | Integer | 0 | Total devices registered under account |
| preferedordercat | Varchar | 0 | Main category ordered (Laptop & Accessory, Mobile, Fashion, Grocery, Others) |
| satisfactionscore | Integer | 0 | Customer satisfaction score (1 to 5) |
| maritalstatus | Varchar | 0 | Marital Status (Single, Married, Divorced) |
| numberofaddress | Integer | 0 | Total registered addresses |
| complain | Integer | 0 | Complaint raised in last month (1 = Yes, 0 = No) |
| orderamounthikefromlastyear | Float | 265 | Percentage hike in order amount from last year (Imputed via Median) |
| couponused | Float | 256 | Number of coupons used (Imputed via Median) |
| ordercount | Float | 258 | Total count of orders placed (Imputed via Median) |
| daysincelastorder | Float | 307 | Days elapsed since last order (Imputed via Median) |
| cashbackamount | Float | 0 | Average cashback amount earned |

---

## 🧹 Data Preprocessing & Cleaning Strategy

Data preprocessing was performed using Python's Pandas library to ensure data integrity before database ingestion:

- Missing Value Imputation: Skewed numerical attributes (tenure, warehousetohome, hourspendonapp, ordercount, etc.) were imputed using Median Imputation to avoid bias caused by extreme outliers.
- Categorical Imputation: Any missing categorical strings were set to 'Unknown'.
- Column Standardization: All column names were transformed into lowercase (df.columns.str.lower()) for seamless compatibility with PostgreSQL syntax.

---

## 📈 Key SQL Analytics & Queries

### 1. Overall Customer Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn)::NUMERIC / COUNT(*)) * 100, 2) AS churn_rate_percentage
FROM ecommerce_churn;

### 2. Device Standardization Analysis
SELECT 
    CASE 
        WHEN LOWER(preferredlogindevice) = 'phone' THEN 'Mobile Phone'
        WHEN LOWER(preferredlogindevice) = 'mobile phone' THEN 'Mobile Phone'
        ELSE preferredlogindevice 
    END AS device_type,
    COUNT(*) AS user_count
FROM ecommerce_churn 
GROUP BY 1;

### 3. Customer Complaints vs. Churn Rate
SELECT
    complain,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn)::NUMERIC / COUNT(*)) * 100, 2) AS churn_rate
FROM ecommerce_churn
GROUP BY complain;

### 4. Distance from Warehouse vs. Churn
SELECT 
    churn, 
    ROUND(AVG(warehousetohome)::numeric, 2) AS avg_distance_from_warehouse
FROM ecommerce_churn
GROUP BY churn;

---

## 🔍 Major Business Insights

| Metric / Dimension | Observation & Impact | Strategic Recommendation |
| :--- | :--- | :--- |
| Warehouse Distance | Churned customers live farther on average (16.86 km) compared to retained customers (15.31 km). | Optimize delivery routes or introduce localized fulfillment hubs to reduce shipping times. |
| Customer Complaints | Customers who raised complaints exhibit significantly higher churn rates. | Prioritize customer support resolution time and offer retention coupons after issue escalation. |
| Device Consistency | Significant overlap between Phone and Mobile Phone logins. | Unify mobile UX across apps and mobile web to ensure seamless user engagement. |

---

## 📁 Project Structure

├── E Commerce Dataset (3).xlsx   # Raw source dataset
├── ecommerce_churn_cleaned.xlsx # Cleaned Excel dataset
├── data_pipeline.py              # Automated ETL script (Pandas + SQLAlchemy)
├── queries.sql                   # SQL Analytical queries
└── README.md                     # Project documentation

---

## 🚀 How to Run

### Prerequisites
- Python 3.10+
- PostgreSQL Server & pgAdmin 4
- Required Libraries: pandas, sqlalchemy, psycopg2, openpyxl

### Setup Instructions

1. Clone the Repository
   git clone https://github.com/sharath45-cloud/ECommerce-Customer-Churn-Analysis
   cd ecommerce-churn-analysis

2. Install Dependencies
   pip install pandas sqlalchemy psycopg2 openpyxl

3. Configure Database Connection
   Update data_pipeline.py with your PostgreSQL credentials:
   DB_USER = 'postgres'
   DB_PASSWORD = 'your_password'
   DB_HOST = 'localhost'
   DB_PORT = '5432'
   DB_NAME = 'postgres'

4. Run the ETL Data Pipeline
   python data_pipeline.py

5. Execute SQL Queries
   Open queries.sql in pgAdmin or your SQL editor and execute queries to generate analytics.

---

## 📄 License
This project is open-source and available under the MIT License.
