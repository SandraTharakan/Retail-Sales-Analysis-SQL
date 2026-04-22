
CREATE TABLE retail_sales
(
transactions_id INT,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);


ALTER TABLE retail_sales
ADD PRIMARY KEY(transactions_id);


SELECT * FROM  retail_sales
LIMIT 50;



--DATA CLEANING (NULL VALUE CHECK)
SELECT COUNT(*) FROM retail_sales
WHERE 
	transactions_id	IS NULL
	OR
	sale_date	IS NULL
	OR	
	sale_time	IS NULL
	OR	
	customer_id	IS NULL
	OR	
	gender	IS NULL
	OR	
	age	IS NULL
	OR	
	category	IS NULL
	OR	
	quantiy	IS NULL
	OR
	price_per_unit	IS NULL
	OR
	cogs	IS NULL
	OR
	total_sale	IS NULL
	

--DATA EXPLORATION-
--Q] How many sales we have ?
SELECT COUNT(total_sale) FROM retail_sales
--OR
SELECT COUNT(*) as total_sale FROM retail_sales

--Q] How many unique customers are there?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales

--Q] Distinct category?
SELECT DISTINCT Category FROM retail_sales

--Q] Date Range of Data
SELECT MIN(sale_date), MAX(sale_date) FROM retail_sales



--Data Analysis and Business key problems

--1. Retrieve all transactions made on '2022-11-05'
--2. Retrieve transaction details where category is 'Clothing' and quantity ≥ 4 in Nov 2022
--3. Calculate the total sales for each category.
--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--8. Write a SQL query to find the top 5 customers based on the highest total sales 
--9. Write a SQL query to find the number of unique customers who purchased items from each category.
--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
--11. Write a SQL Query to calculate Gross Profit and Profit Margin by Category
--12. Write a SQL Query to Find highest Category by Profit in Each Year (Most profitable category per year)
--13. Write a SQL Query to Find the Monthly Revenue Growth Rate (%)
--14. Write a SQL Query to Identify Repeat Customers(low, medium, high) vs One-time Customers
--15. Write a SQL Query to Calculate Customer Lifetime Value (CLV)
--16. Write a SQL Query to Detect Customers with Increasing Spending Trend (Monthly)
--17. Write a SQL Query to Find Peak Sales Hour of the Day
-- 18. Write a SQL Query to Category Contribution % to Total Revenue ([category revenue/total revenue] *100)
-- 19. Cohort Retention Analysis





--1. Retrieve all transactions made on '2022-11-05'
SELECT * FROM retail_sales
WHERE Sale_date = '2022-11-05'


--2. Retrieve transaction details where category is 'Clothing' and quantity ≥ 4 in Nov 2022
SELECT * FROM retail_sales
WHERE   category='Clothing'
AND quantiy >= 4 
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
--OR-------------------------------
SELECT * FROM retail_sales
WHERE   category='Clothing'
AND quantiy >= 4 
AND TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'


--3. Calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale)AS net_sale, 
	COUNT(*) AS Total_orders 
FROM retail_sales
GROUP BY category
--INSIGHT: Electronics generates the highest revenue, indicating it is the top-performing product category.


--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	category,
	ROUND(AVG(age),2) AS Avg_cust_Age,
	COUNT(*) AS Total_cust
FROM retail_sales
WHERE Category='Beauty'
GROUP BY category


--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale>1000


--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	Category,
	gender,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY 
    category,
    gender
ORDER BY 1


--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH TABLE2 AS
(
SELECT 
	TO_CHAR(sale_date,'YYYY') AS Year,
	TO_CHAR(sale_date,'MM') AS Month,
	ROUND(AVG(total_sale)::numeric,2) AS Avg_salePerMonth,
	RANK() OVER (PARTITION BY TO_CHAR(sale_date,'YYYY') ORDER BY AVG(total_sale) DESC ) AS rank
	--SUM(total_sale) AS total
FROM retail_sales
GROUP BY 1,2
)
SELECT * FROM TABLE2 WHERE rank=1


--8. Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS Cust_count
FROM retail_Sales
GROUP BY 1
ORDER BY 1


--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT COUNT(*) AS NumOfOrders,
CASE
	WHEN EXTRACT(HOUR FROM sale_time )<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN EXTRACT(HOUR FROM sale_time )>17 THEN 'Evening'
END AS Hour_sale
FROM retail_sales
GROUP BY Hour_sale


--11. Write a SQL Query to calculate Gross Profit and Profit Margin by Category
SELECT 
	category, 
	SUM(total_sale) AS Total_revenue, 
	ROUND(SUM(cogs)::numeric,2) AS Total_cogs,
	ROUND(SUM(total_sale-cogs)::numeric,2) AS Profit,
	ROUND((SUM(total_sale-cogs)/SUM(total_sale))::numeric,2) *100 AS Profit_Margin
	FROM retail_sales
GROUP BY 1


--12. Find highest Category by Profit in Each Year (Most profitable category per year)
WITH Table3 AS(
SELECT 
	TO_CHAR(sale_date,'YYYY') AS Sale_Year,
	Category,
	SUM(total_sale) AS total_revenue,
	SUM(cogs) AS total_cogs,
	ROUND(SUM(total_sale-cogs)::numeric,2) AS Profit,
	RANK() OVER 
		(
		PARTITION BY TO_CHAR(sale_date,'YYYY') 
		ORDER BY ROUND(SUM(total_sale-cogs)::numeric,2)
		) AS Profit_rank
FROM retail_sales
GROUP BY 1,2
)

SELECT * FROM Table3
WHERE profit_rank=1


--13. Find the Monthly Revenue Growth Rate (%)
SELECT
	TO_CHAR(sale_date,'YYYY-MM') AS sale_Month,
	SUM(Total_sale) AS total_revenue,
	LAG(SUM(Total_sale)) OVER (ORDER BY TO_CHAR(sale_date,'YYYY-MM')) AS Lag_revenue,
	ROUND(
	(
	  (
		( SUM(Total_sale)- LAG(SUM(Total_sale)) OVER (ORDER BY TO_CHAR(sale_date,'YYYY-MM')) )/
			NULLIF( LAG(SUM(Total_sale)) OVER (ORDER BY TO_CHAR(sale_date,'YYYY-MM')),0)
	  )*100
	)::numeric , 2 ) AS Growth_Rate
FROM retail_sales
GROUP BY 1


--14. Identify Repeat Customers(low, medium, high) vs One-time Customers
SELECT 
	Customer_id,
	COUNT(Customer_id) AS customer_count,
	CASE
		WHEN COUNT(Customer_id)=1 THEN '1One-Timer'
		WHEN COUNT(Customer_id)>1 and COUNT(Customer_id)<11 THEN '2Low-Repeater'
		WHEN COUNT(Customer_id)>10 and COUNT(Customer_id)<21 THEN '3Med-Repeater'
		ELSE '4High-Repeater'
	END AS Customer_freq
FROM retail_sales
GROUP BY 1
ORDER BY Customer_freq


-- 15. Calculate Customer Lifetime Value (CLV)
SELECT 
	Customer_id,
	COUNT(transactions_id) AS total_transactions,
	SUM(total_sale)AS total_purchaseAmt_CLV,
	ROUND( (SUM(total_sale)/ COUNT(transactions_id))::numeric ,2) AS avg_orderValue,
	RANK() OVER (ORDER BY (SUM(total_sale)) DESC) AS rank
FROM retail_sales
GROUP BY 1


-- 16. Detect Customers with Increasing Spending Trend (Monthly)
SELECT 
	customer_id,
	DATE_TRUNC('month', sale_date) AS Month,
	SUM (total_sale) AS Monthly_sale_per_cust,
	LAG(SUM (total_sale)) OVER (PARTITION BY customer_id ORDER BY DATE_TRUNC('month', sale_date) ) AS Prev_month_sale_per_cust,
	ROUND( ( ( (SUM (total_sale) - LAG(SUM (total_sale)) OVER (PARTITION BY customer_id ORDER BY DATE_TRUNC('month', sale_date) ) ) /
	NULLIF( LAG(SUM (total_sale)) OVER (PARTITION BY customer_id ORDER BY DATE_TRUNC('month', sale_date) ), 0) ) * 100)::numeric, 2)
	AS Monthly_Growthrate
FROM retail_sales
GROUP BY 1,2
ORDER BY 1


--17. Find Peak Sales Hour of the Day
--get the ranking on the hours per day based on the hourly revenue
WITH hourly_sale_data AS (
SELECT 
	sale_date,
	DATE_TRUNC('HOUR',sale_time)Hours,
	SUM(total_sale) AS hourly_total_sale,
	RANK() OVER (PARTITION BY Sale_date ORDER BY SUM(total_sale) DESC) AS rank
FROM Retail_sales
GROUP BY 1,2
ORDER BY 1),

--filter out the peak hours per day (hours with the highest revenue on that day)
Peak_Hour AS (
SELECT * FROM hourly_sale_data
WHERE rank=1)

--during all those days, which hours had the highest revenue
SELECT 
	Hours,
	--sale_date,
	COUNT(sale_date) AS Freq_at_Hours
	--COUNT(sale_date) OVER (PARTITION BY hours) AS Freq_at_Hours
FROM Peak_Hour
GROUP BY 1
ORDER BY Freq_at_Hours DESC


-- 18. Write a SQL Query to Category Contribution % to Total Revenue ([category revenue/total revenue] *100)
SELECT 
	category,
	SUM(total_sale) AS Category_revenue,
	SUM(SUM(total_sale)) OVER() AS net,
	ROUND(((SUM(total_sale)/ SUM(SUM(total_sale)) OVER())*100)::numeric,2) AS Category_Contribution
FROM retail_sales
GROUP BY 1


-- 19. Cohort Retention Analysis
--the first purchase month of each customer
WITH Cohort_data AS(
SELECT 
	customer_id,
	MIN (DATE_TRUNC('Month',sale_date)) AS Cohort_month
FROM retail_sales
GROUP BY 1
ORDER BY 2
),

-- active months of each customer
Activity_data AS(
SELECT
	customer_id,
	DATE_TRUNC('Month',sale_date) AS Active_month
FROM retail_sales
ORDER BY 1,2
),

--Join Cohort month and activity month
Cohort_Activity_data AS(
SELECT c.customer_id ,c.Cohort_month, a.Active_month
FROM Cohort_data c
INNER JOIN Activity_data a
ON c.customer_id=a.customer_id
),

--difference ([Active_Year- Cohort_Year]*12)+(Active_month - Cohort_month)
CALC_Month_Index AS(
SELECT
	customer_id,
	cohort_month,
	active_month,
	( ((EXTRACT(YEAR FROM active_month)- EXTRACT(YEAR FROM cohort_month))*12) + (EXTRACT(MONTH FROM active_month)- EXTRACT(MONTH FROM cohort_month)) ) AS Month_index
FROM Cohort_Activity_data
)

--FInal
SELECT 
	cohort_month,
	Month_index,
	COUNT(DISTINCT customer_id)
FROM CALC_Month_Index
GROUP BY 1,2
ORDER BY 1,2



