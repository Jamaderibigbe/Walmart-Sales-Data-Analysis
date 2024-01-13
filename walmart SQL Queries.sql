-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- use the DATABASE
USE walmartsales;
-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
	city VARCHAR(30) NOT NULL,
	customer_type VARCHAR(30) NOT NULL,
	gender VARCHAR(10) NOT NULL,
	product_line VARCHAR(100) NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	quantity INT NOT NULL,
	tax_pct FLOAT(6,4) NOT NULL,
	total DECIMAL(12, 4) NOT NULL,
	date DATETIME NOT NULL,
	time TIME NOT NULL,
	payment_method VARCHAR(15) NOT NULL,
	cogs DECIMAL(10,2) NOT NULL,
	gross_margin_pct FLOAT(11,9),
	gross_income DECIMAL(12, 4),
	rating FLOAT(2, 1)
);

/* Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening.
 This will help answer the question on which part of the day most sales are made*/
 
 SELECT 
	time,
    ( CASE
		WHEN time BETWEEN  "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN  "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_day
 FROM sales;

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN  "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN  "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);

/*Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri).
 This will help answer the question on which week of the day each branch is busiest.*/
 
 SELECT 
	date,
    DAYNAME(date) AS day_name
FROM 
	sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

/*Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).
 Help determine which month of the year has the most sales and profit.*/
 
 SELECT
	date,
    MONTHNAME(date)
FROM sales;
 
 ALTER TABLE sales
 ADD COLUMN month_name VARCHAR(20);
 
 UPDATE sales
 SET month_name = MONTHNAME(date);
 
 -- Generic Question
 
-- 1. How many unique cities does the data have?

SELECT
	DISTINCT city
FROM sales;

-- 2. In which city is each branch?

SELECT
	DISTINCT city,
    branch
FROM
	sales;
    

-- Product

-- 1. How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;

-- 2. What is the most common payment method?
SELECT
	payment_method,
    COUNT(payment_method) AS Count_of_payment_method
FROM sales
GROUP BY payment_method
ORDER BY Count_of_payment_method DESC;

-- 3. What is the most selling product line?
SELECT
	product_line,
    COUNT(product_line) AS Count_of_product_line
FROM sales
GROUP BY product_line
ORDER BY Count_of_product_line DESC;

-- 4. What is the total revenue by month?
SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?
SELECT 
	month_name AS month,
    SUM(cogs) AS cost_of_goods
FROM sales
GROUP BY month_name
ORDER BY cost_of_goods DESC;

-- 6. What product line had the largest revenue?
SELECT 
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT
	branch,
    city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- 8. What product line had the largest VAT?
SELECT
	product_line,
    AVG(tax_pct) AS Avg_tax
FROM sales
GROUP BY product_line
ORDER BY Avg_tax DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- 10. Which branch sold more products than average product sold?
SELECT
	branch,
    SUM(quantity) AS Quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- 11. What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS Count_of_Gender
FROM sales
GROUP BY gender, product_line
ORDER BY Count_of_Gender DESC;

-- 12. What is the average rating of each product line?
SELECT 
	product_line,
    ROUND(AVG(rating), 2) AS Avg_rating
FROM sales
GROUP BY product_line
ORDER BY Avg_rating DESC;

-- Sales
-- 1. Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
    day_name,
    COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day, day_name
ORDER BY total_sales DESC;

-- 2. Which of the customer types brings the most revenue?
SELECT
	customer_type,
    ROUND(SUM(total), 2)  AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(tax_pct) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- 4. Which customer type pays the most in VAT?
SELECT 
	customer_type,
    SUM(tax_pct) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- Customer

-- 1. How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- 2. How many unique payment methods does the data have?
SELECT
	DISTINCT payment_method
FROM sales;

-- 3. What is the most common customer type?
SELECT
	customer_type,
    COUNT(customer_type) AS num_cust_type
FROM sales
GROUP BY customer_type;

-- 4. Which customer type buys the most?
SELECT 
	customer_type,
    COUNT(*) AS customer_count
FROM sales
GROUP BY customer_type;

-- 5. What is the gender of most of the customers?
SELECT
	gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender;

-- 6. What is the gender distribution per branch?
-- you can check for any branch (A,B & C) using the 'WHERE' clause
SELECT
	gender,
    COUNT(*) AS gender_count
FROM sales
WHERE branch = "C"
GROUP BY gender;

-- 7. Which time of the day do customers give most ratings?
SELECT
	tIme_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 8. Which time of the day do customers give most ratings per branch?
-- you can check for any branch (A,B & C) using the 'WHERE' clause
SELECT
	tIme_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 9. Which day of the week has the best avg ratings?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 10. Which day of the week has the best average ratings per branch?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rating DESC;