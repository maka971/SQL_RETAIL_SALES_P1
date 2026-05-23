
---Data Exploration & Cleaning
--Record Count: Determine the total number of records in the dataset.
---stomer Count: Find out how many unique customers are in the dataset.
---Category Count: Identify all unique product categories in the dataset.
---Null Value Check: Check for any null values in the dataset and delete records with missing data.






SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

---DATA CLEANING ----

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
SELECT * FROM retail_sales;
SELECT
    COUNT(*) 
FROM retail_sales;

---DATA CLEANING ----

SELECT * FROM retail_sales
Where transactions_id IS null

SELECT * FROM retail_sales
Where sale_date IS null

SELECT * FROM retail_sales
Where sale_time IS null

SELECT * FROM retail_sales
Where
     sale_time IS null
     or
     transactions_id IS null
     or
     customer_id IS null
     or
     gender is null
     or 
     age is null
     or 
     category is null
     or 
     quantity is null 
     or 
     price_per_unit is null
     or 
     cogs is null
     or 
     total_sale is null


     DELETE FROM retail_sales
     Where
     sale_time IS null
     or
     transactions_id IS null
     or
     customer_id IS null
     or
     gender is null
     or 
     age is null
     or 
     category is null
     or 
     quantity is null 
     or 
     price_per_unit is null
     or 
     cogs is null
     or 
     total_sale is null


SELECT
    COUNT(*) 
FROM retail_sales;



---DATA EXPLORATION 
---The following SQL queries were developed to answer specific business questions:

----HOW MANY SALES WE HAVE ?
Select count(*) as total_sale From retail_sales

-----HOW MANY UNIUQUE CUSTOMERS WE HAVE?
Select count(DISTINCT customer_id) as total_sale From retail_sales


Select DISTINCT category From retail_sales


-------Data ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS
----Write a SQL query to retrieve all columns for sales made on '2022-11-05:

Select *
from retail_sales
WHERE sale_date = 2022-11-05;

---CONVERT DATE TYPE =------
SELECT *
FROM retail_sales
WHERE CONVERT(DATE, sale_date, 101) = '2022-11-05';

------Write a SQL query to retrieve all transactions where the category is 
---'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND FORMAT(CONVERT(DATE, sale_date, 101), 'yyyy-MM') = '2022-11'
    AND quantity >= 4


    -------Write a SQL query to calculate the total sales (total_sale) for each category.:-

    Select
         category,
         sum(total_sale) as net_sale,
         count(*) as total_orders
    From retail_sales
    GROUP BY category

    ----------Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

    SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


----Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale > 1000

----Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:


SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1

----Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT year, month, avg_sale
FROM (
    SELECT
        YEAR(CONVERT(DATE, sale_date, 101)) AS year,
        MONTH(CONVERT(DATE, sale_date, 101)) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(CONVERT(DATE, sale_date, 101))
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 
        YEAR(CONVERT(DATE, sale_date, 101)),
        MONTH(CONVERT(DATE, sale_date, 101))
) AS t1
WHERE rank = 1

----Write a SQL query to find the top 5 customers based on the highest total sales

SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC

------Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

---Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

--end of the project---