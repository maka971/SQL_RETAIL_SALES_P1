<div align="center">

# 🗃️ Retail Sales Analysis — SQL Project
### SQL · Data Cleaning · Exploratory Data Analysis · Business Querying

**Exploring, cleaning, and analyzing retail sales data using SQL — from database setup through to answering real business questions.**

![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mutyaba-sulah-525510203/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/maka971)

</div>

---

## 📑 Table of Contents

- [📌 Project Overview](#-project-overview)
- [🎯 Objectives](#-objectives)
- [📁 Repository Structure](#-repository-structure)
- [🏗️ Database Setup](#️-database-setup)
- [🧹 Data Exploration & Cleaning](#-data-exploration--cleaning)
- [❓ Business Questions Answered](#-business-questions-answered)
- [💡 Key Findings](#-key-findings)
- [📊 Reports](#-reports)
- [🚀 How to Use](#-how-to-use)
- [🛠️ Tech Stack](#️-tech-stack)
- [📈 Skills Demonstrated](#-skills-demonstrated)
- [👨‍💻 About the Author](#-about-the-author)

---

## 📌 Project Overview

**Project Title:** Retail Sales Analysis
**Database:** `p1_retail_db`

This project demonstrates SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. It covers setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries — a solid foundation-building project for anyone starting their data analyst journey.

---

## 🎯 Objectives

1. **Set up a retail sales database** — create and populate it with the provided sales data
2. **Data cleaning** — identify and remove any records with missing or null values
3. **Exploratory Data Analysis (EDA)** — understand the shape and structure of the dataset
4. **Business analysis** — use SQL to answer specific business questions and derive insights

---

## 📁 Repository Structure

```
SQL_RETAIL_SALES_P1/
│
├── SQL - Retail Sales Analysisss.csv     # Raw retail sales dataset
├── SQLQuery project1.sql                 # Full SQL script: setup, cleaning & analysis queries
└── README.md
```

---

## 🏗️ Database Setup

The project starts by creating a database named `p1_retail_db`, with a `retail_sales` table storing transaction-level data — transaction ID, sale date/time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

> 💡 **Note:** For importing the CSV data into your own SQL Server / PostgreSQL instance, you can use whichever import method your tool supports (e.g. `COPY`, the pgAdmin import wizard, or SSMS's Import Flat File).

---

## 🧹 Data Exploration & Cleaning

| Step | Purpose |
|---|---|
| Record Count | Determine the total number of records in the dataset |
| Customer Count | Find out how many unique customers are in the dataset |
| Category Count | Identify all unique product categories |
| Null Value Check | Check for and remove any records with missing data |

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

---

## ❓ Business Questions Answered

<details>
<summary><strong>1. Retrieve all sales made on '2022-11-05'</strong></summary>

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```
</details>

<details>
<summary><strong>2. Transactions where category is 'Clothing' with quantity > 4 in Nov-2022</strong></summary>

```sql
SELECT *
FROM retail_sales
WHERE
    category = 'Clothing'
    AND
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;
```
</details>

<details>
<summary><strong>3. Total sales (total_sale) for each category</strong></summary>

```sql
SELECT
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;
```
</details>

<details>
<summary><strong>4. Average age of customers who purchased from the 'Beauty' category</strong></summary>

```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
```
</details>

<details>
<summary><strong>5. All transactions where total_sale is greater than 1000</strong></summary>

```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```
</details>

<details>
<summary><strong>6. Total number of transactions made by each gender in each category</strong></summary>

```sql
SELECT
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY
    category,
    gender
ORDER BY 1;
```
</details>

<details>
<summary><strong>7. Average sale for each month & best-selling month per year</strong></summary>

```sql
SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        AVG(total_sale) as avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
    FROM retail_sales
    GROUP BY 1, 2
) as t1
WHERE rank = 1;
```
</details>

<details>
<summary><strong>8. Top 5 customers based on highest total sales</strong></summary>

```sql
SELECT
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
</details>

<details>
<summary><strong>9. Number of unique customers who purchased from each category</strong></summary>

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;
```
</details>

<details>
<summary><strong>10. Orders by shift (Morning / Afternoon / Evening)</strong></summary>

```sql
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;
```
</details>

---

## 💡 Key Findings

- 👥 **Customer Demographics** — The dataset includes customers from various age groups, with sales distributed across categories such as Clothing and Beauty
- 💰 **High-Value Transactions** — Several transactions exceeded a total sale amount of 1,000, indicating premium purchases
- 📅 **Sales Trends** — Monthly analysis reveals variations in sales, helping identify peak seasons
- 🏆 **Customer Insights** — The analysis surfaces top-spending customers and the most popular product categories

---

## 📊 Reports

- **Sales Summary** — total sales, customer demographics, and category performance
- **Trend Analysis** — sales trends across different months and shifts
- **Customer Insights** — top customers and unique customer counts per category

---

## 🚀 How to Use

1. **Clone the repository**
   ```bash
   git clone https://github.com/maka971/SQL_RETAIL_SALES_P1.git
   ```

2. **Set up the database** — run the `CREATE DATABASE` / `CREATE TABLE` statements from `SQLQuery project1.sql` in your SQL environment (PostgreSQL, SQL Server, etc.)

3. **Load the data** — import `SQL - Retail Sales Analysisss.csv` into the `retail_sales` table using your tool's import method

4. **Run the queries** — execute the analysis queries in `SQLQuery project1.sql` to reproduce the findings above

5. **Explore and modify** — adapt the queries to explore different aspects of the dataset or answer additional business questions

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| SQL (PostgreSQL syntax) | Database creation, data cleaning, and analysis |
| CSV | Raw data source |

---

## 📈 Skills Demonstrated

- ✅ Database and table design
- ✅ Data cleaning and null-value handling
- ✅ Exploratory data analysis via SQL
- ✅ Aggregate functions, `GROUP BY`, and filtering
- ✅ Window functions (`RANK() OVER PARTITION BY`)
- ✅ Common Table Expressions (CTEs)
- ✅ Date/time extraction and conditional logic (`CASE WHEN`)
- ✅ Translating business questions into SQL queries

---

## 👨‍💻 About the Author

**Sulah Mutyaba**
Data Analyst | Power BI Developer | SQL | Python

- 📧 sulahmutyaba@gmail.com
- 💼 LinkedIn: [linkedin.com/in/mutyaba-sulah-525510203](https://www.linkedin.com/in/mutyaba-sulah-525510203/)
- 💻 GitHub: [github.com/maka971](https://github.com/maka971)
- 📍 Dubai, UAE | +971 55 619 1280

*This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!*

---

<div align="center">

*Built as part of a data analytics portfolio. Open to feedback and collaboration.*

</div>
