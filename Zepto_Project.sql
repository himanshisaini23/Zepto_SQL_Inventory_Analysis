CREATE  DATABASE Zepto_SQL_Project;
DROP TABLE IF EXISTS Zepto;
USE Zepto_SQL_project;

create table zepto (
sku_id INT AUTO_INCREMENT PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp DECIMAL(8,2),
discountPercent DECIMAL(5,2),
availableQuantity INT,
discountedSellingPrice DECIMAL(8,2),
weightInGms INT,
outOfStock VARCHAR(5),	
quantity INT
);

-- count of rows
select COUNT(*) from zepto;
SELECT * FROM Zepto;

-- null values
SELECT * FROM Zepto
WHERE name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
availableQuantity is NULL
OR
discountedSellingPrice is NULL
OR
weightInGms is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

-- different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock vs out of stock
SELECT outOfStock, count(sku_id)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, count(sku_id) as 'Number of SKUs'
FROM Zepto
GROUP BY name
HAVING count(sku_id)> 1
ORDER BY COUNT(sku_id) desc;

#products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;
delete FROM Zepto 
WHERE mrp = 0;

#convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

#data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent, discountedSellingPrice
FROM zepto
ORDER BY discountPercent desc
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp, outofstock
FROM zepto
WHERE outOfStock= 'TRUE' AND mrp> 200
ORDER BY mrp desc;

-- Q3.Calculate Estimated Revenue for each category
SELECT category, sum(discountedsellingprice*availableQuantity) as Total_Revenue
FROM zepto
GROUP BY category
ORDER BY  Total_Revenue desc;

-- Q4.Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name , mrp , discountPercent
FROM zepto
WHERE mrp> 500 AND discountPercent< 10
ORDER BY mrp desc , discountPercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, round(avg(discountpercent),2) AS Avg_Discount
FROM zepto
GROUP BY category
ORDER BY Avg_Discount desc
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms,discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
	CASE WHEN weightInGms < 1000 THEN 'Low'
		WHEN weightInGms < 5000 THEN 'Medium'
        ELSE 'Bulk'
        END AS Weight_category
FROM zepto;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category, sum(weightInGms*availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight desc;
