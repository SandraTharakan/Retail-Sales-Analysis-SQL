/*
CREATE TABLE retail_sales
(
transactions_id INT,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(10),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);
*/
/*
ALTER TABLE retail_sales
ADD PRIMARY KEY(transactions_id);

ALTER TABLE  retail_sales
ALTER category TYPE VARCHAR(15);
*/

SELECT * FROM  retail_sales
LIMIT 50;

SELECT COUNT(*) FROM retail_sales;

--Data cleaning(NULL VALUE CHECK)---
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
--4. Find the average age of customers who purchased items from the 'Beauty' category.
--5. Find all transactions where the total_sale is greater than 1000.
--6. Find the total number of transactions (transaction_id) made by each gender in each category.
--7. Calculate the average sale for each month. Find out best selling month in each year
--8. Find the top 5 customers based on the highest total sales 
--9. Find the number of unique customers who purchased items from each category.
--10. Categorize transactions into shifts (Morning, Afternoon, Evening) and count orders
--11. Calculate Gross Profit and Profit Margin by Category
--12. Find highest Category by Profit in Each Year (Most profitable category per year)
--14. Classify customers as one-time, low, medium, high repeat customers
--15. Calculate Customer Lifetime Value (CLV)
--16. Detect Customers with Increasing Spending Trend (Monthly)
--17. Find Peak Sales Hour of the Day
-- 18. Calculate Category Contribution % to Total Revenue ([category revenue/total revenue] *100)
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
--INSIGHT: Electronic products generates the highest revenue, indicating it is the top-performing product category.


--4. Find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	category,
	ROUND(AVG(age),2) AS Avg_cust_Age,
	COUNT(*) AS Total_cust
FROM retail_sales
WHERE Category='Beauty'
GROUP BY category
--INSIGHT: Beauty category shows higher engagement among middle-aged customers.


--5. Find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale>1000


--6. Find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	Category,
	gender,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY 
    category,
    gender
ORDER BY 1
--INSIGHT: Female customers dominate transactions in the Beauty category, while gender-based transaction differences are minimal in other categories.


--7. Calculate the average sale for each month. Find out best selling month in each year
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
--INSIGHT: The average monthly sales range between 350 and 550, with July 2022 and February 2023 emerging as the peak months in their respective year.


--8. Find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
--INSIGHT: Sales are relatively well distributed across customers, with no heavy reliance on a small group of top customers.


--9. Find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS Cust_count
FROM retail_Sales
GROUP BY 1
ORDER BY 1
--INSIGHT: Customer distribution is fairly uniform across categories, indicating balanced customer interest across product segments.


--10.Categorize transactions into shifts (Morning, Afternoon, Evening) and count orders
SELECT COUNT(*) AS NumOfOrders,
CASE
	WHEN EXTRACT(HOUR FROM sale_time )<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN EXTRACT(HOUR FROM sale_time )>17 THEN 'Evening'
END AS Hour_sale
FROM retail_sales
GROUP BY Hour_sale
-- INSIGHT: A significant portion of transactions occurs during the evening hours, making it the peak sales period of the day.


--11. Calculate Gross Profit and Profit Margin by Category
SELECT 
	category, 
	SUM(total_sale) AS Total_revenue, 
	ROUND(SUM(cogs)::numeric,2) AS Total_cogs,
	ROUND(SUM(total_sale-cogs)::numeric,2) AS Profit,
	ROUND((SUM(total_sale-cogs)/SUM(total_sale))::numeric,2) *100 AS Profit_Margin
	FROM retail_sales
GROUP BY 1
--INSIGHT: All categories exhibit similar profit margins (~79–80%), suggesting uniform profitability and a consistent cost-to-revenue ratio across products.


--12. Find highest Category by Profit in Each Year (Most profitable category per year)
WITH Category_profit AS(
SELECT 
	TO_CHAR(sale_date,'YYYY') AS Sale_Year,
	Category,
	SUM(total_sale) AS total_revenue,
	SUM(cogs) AS total_cogs,
	ROUND(SUM(total_sale-cogs)::numeric,2) AS Profit,
	RANK() OVER 
		(
		PARTITION BY TO_CHAR(sale_date,'YYYY') 
		ORDER BY ROUND(SUM(total_sale-cogs)::numeric,2) DESC
		) AS Profit_rank
FROM retail_sales
GROUP BY 1,2
)

SELECT * FROM Category_profit
WHERE profit_rank=1
-- INSIGHT: The most profitable category shifts from Electronics in 2022 to Clothing in 2023, indicating a change in customer demand or product performance over time.


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
-- INSIGHT: Monthly revenue growth rate shows fluctuations across the period, with noticeable sharp revenue growth in September 2022 and September 2023, indicating recurring seasonal surges in sales.


--14. Classify customers as one-time, low, medium, high repeat customers
SELECT 
	Customer_id,
	COUNT(Customer_id) AS customer_count,
	CASE
		WHEN COUNT(Customer_id)=1 THEN 'One-Timer'
		WHEN COUNT(Customer_id)>1 and COUNT(Customer_id)<11 THEN 'Low-Repeater'
		WHEN COUNT(Customer_id)>10 and COUNT(Customer_id)<21 THEN 'Med-Repeater'
		ELSE 'High-Repeater'
	END AS Customer_freq
FROM retail_sales
GROUP BY 1
ORDER BY customer_count
/* INSIGHT: All customers are repeat buyers, with no one-time customers observed, indicating strong customer retention. 
			Some customers exhibit high engagement, with purchase frequencies reaching up to 76 transactions. */

-- 15. Calculate Customer Lifetime Value (CLV)
SELECT 
	Customer_id,
	COUNT(transactions_id) AS total_transactions,
	SUM(total_sale)AS total_purchaseAmt_CLV,
	ROUND( (SUM(total_sale)/ COUNT(transactions_id))::numeric ,2) AS avg_orderValue
	--RANK() OVER (ORDER BY (SUM(total_sale)) DESC) AS rank
FROM retail_sales
GROUP BY 1
ORDER BY 4 DESC
-- INSIGHT: Customer lifetime value is relatively well distributed across customers


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
/* INSIGHT: Customer spending shows an overall increasing trend, with no negative growth observed, 
			indicating steadily rising customer value over time despite minor fluctuations. */


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
-- INSIGHT: The 7 PM to 8 PM time slot generates the highest revenue across days, indicating peak sales activity during evening hours.


-- 18. Calculate Category Contribution % to Total Revenue ([category revenue/total revenue] *100)
SELECT 
	category,
	SUM(total_sale) AS Category_revenue,
	SUM(SUM(total_sale)) OVER() AS total_revenue,
	ROUND(((SUM(total_sale)/ SUM(SUM(total_sale)) OVER())*100)::numeric,2) AS Category_Contribution
FROM retail_sales
GROUP BY 1
-- INSIGHT: Revenue contribution is fairly evenly distributed across categories, indicating a balanced dependence on different product segments.


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
	COUNT(DISTINCT customer_id) AS No_of_cutomers
FROM CALC_Month_Index
GROUP BY 1,2
ORDER BY 1,2

-- INSIGHT: Customer retention gradually decreases over subsequent months, indicating diminishing engagement over time.



