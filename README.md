# 🛍️ Retail Analytics SQL Project

## 📌 Overview
This project performs **end-to-end data cleaning and analysis** on a retail dataset containing sales transactions, customer profiles, and product inventory.  
Using SQL, the project identifies inconsistencies, cleans the data, and extracts key business insights such as sales trends, customer segmentation, and product performance.

---

## 📂 Dataset
This project uses three core tables:

- **sales_transaction** – Sales transaction data  
- **customer_profiles** – Customer demographic information  
- **product_inventory** – Product category & price details  

---

## 🧹 Data Cleaning Performed
- Removed BOM characters from column names  
- Identified & removed duplicate transactions  
- Fixed price mismatches between sales and inventory tables  
- Replaced NULL/blank customer locations with `'Unknown'`  
- Cleaned and standardized the date field  
- Recreated cleaned tables to ensure data consistency  

---

## 📊 Analysis Performed

### 🔸 Sales Performance
- Total units sold per product  
- Revenue per product  
- Top 10 highest revenue-generating products  
- 10 least selling products  
- Category-wise sales performance  

### 🔸 Customer Insights
- Number of transactions per customer  
- High-value customers (frequent + high spenders)  
- Low-frequency customers  
- Repeat customer behavior  
- Loyalty duration (first vs. last purchase gap)  

### 🔸 Trends & Growth
- Daily revenue and sales trend  
- Month-on-month (MoM) sales growth  
- Customer segmentation: **Low / Medium / High** (based on purchase quantity)  

---

## 🚀 Key Findings
- A few product categories dominate total revenue  
- High-frequency customers contribute significantly to overall sales  
- Low-frequency customers show retention opportunities  
- MoM trend helps identify seasonality and business growth  
- Customer segmentation enables data-driven marketing strategies  

---

## 🧰 Tech Stack
- **MySQL (SQL Queries)**  
- Data cleaning  
- Exploratory data analysis  
- Window functions, joins, grouping  



