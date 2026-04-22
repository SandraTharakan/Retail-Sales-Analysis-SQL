# 🛒 Retail Sales Analysis using PostgreSQL

## About
This project analyzes retail sales data from a fictional store to derive actionable business insights. It demonstrates the use of SQL for data exploration, manipulation, and advanced analysis, including customer behaviour, sales trends, and cohort-based retention. The analysis was performed using PostgreSQL.


## Objective
*	Analyze sales trends over time
*	Identify top customers and categories
*	Understand customer purchasing patterns
*	Perform cohort-based retention analysis


## Dataset Description
Dataset: Sample retail sales dataset (synthetic / practice dataset)
The dataset contains transaction-level data with the following columns:
*	transactions_id – Unique transaction ID
*	sale_date – Date of sale
*	sale_time – Time of sale
*	customer_id – Unique customer ID
*	gender – Customer gender
*	age – Customer age
*	category – Product category
*	quantity – Units purchased
*	price_per_unit – Price per unit
*	cogs - Cost of goods sold
*	total_sale – Total transaction value


## Data Exploration & Cleaning
*	Calculated total number of transactions and unique customers
*	Identified distinct product categories
*	Checked dataset time range
*	Verified data quality by checking for null values across all columns


## Key Analysis Performed
* Sales & Revenue Analysis
    * Total sales by category
	* Monthly sales trends
	* Monthly revenue growth rate (%)
	* Peak sales hour analysis
* Customer Analysis
    *	Top 5 customers by total spending
    *	Customer segmentation (repeat vs one-time)
    *	Customer Lifetime Value (CLV)
    *	Customer spending trend analysis
* Product / Category Analysis
    *	Revenue by category
    *	Profit and profit margin by category
    *	Most profitable category per year
    *	Category contribution to total revenue (%)
* Time-based Analysis
    *	Sales distribution across different shifts (Morning, Afternoon, Evening)
    *	Best-performing months
* Advanced Analysis ⭐
    *	Cohort-based customer retention analysis
    *	Monthly growth behaviour of customers

_Note: For detailed list of  questions, refer to the SQL file in this repository._


## Key Insights
*	Sales performance varies across months, with peak sales observed in July 2022 and February 2023, indicating no fixed seasonal trend.
*	Revenue growth shows fluctuations, with consistent spikes in September across years, suggesting possible seasonal or promotional impact.
*	Evening hours (especially 7–8 PM) generate the highest sales, marking it as the peak business period.
*	Revenue and customer contribution are relatively well distributed across categories and customers, indicating a balanced and stable business structure.
*	Cohort analysis reveals a decline in customer retention over time, indicating reduced long-term engagement after initial purchases.

 
## Learnings
* Used SQL concepts such as:
    *	CTEs (Common Table Expressions)
    *	Window functions (LAG, RANK)
    *	Date functions (DATE_TRUNC, EXTRACT)
* Gained understanding of:
    *	Customer retention and cohort analysis
    *	Business KPI calculations
    *	Data exploration and cleaning techniques


## Tools & Technologies
* PostgreSQL
* SQL

## How to Use
1. Create table using given schema
2. Insert dataset
3. Run SQL queries from the SQL file

## Conclusion
This project demonstrates how SQL can be used to analyze real-world transactional data and generate actionable business insights.


## Author 
Sandra P. Tharakan
