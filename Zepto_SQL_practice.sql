DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(120) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INT,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INT
);

--data exploration

--total no of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto LIMIT 10;

--null values
SELECT * FROM zepto 
WHERE name is NULL
or
mrp is NULL
or
discountPercent is NULL
or
availableQuantity is NULL
or
discountedSellingPrice is NULL
or
weightInGms is NULL
or
outOfStock is NULL
or
quantity is NULL;

--no null values

--different product categories
SELECT DISTINCT(category) FROM zepto ORDER BY category;


--products in stock vs out of stock
SELECT outOfStock,COUNT(sku_id) FROM zepto
GROUP BY outOfStock;

--Product names present multiple times
SELECT name, COUNT(sku_id) AS No_of_SKU
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY No_of_SKU DESC;

--data cleaning

--Products where price might be 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--converting mrp{paise to rupee}
UPDATE zepto
SET mrp = mrp/100.00,
discountedSellingPrice = discountedSellingPrice/100.00;

SELECT mrp, discountedSellingPrice FROM zepto;

--Q1. Whats the top 10 best value products based on discount percentage
SELECT name, category,mrp, discountPercent FROM zepto
ORDER BY discountPercent DESC LIMIT 10;

--Q2. What are products with high MRP but Out Of Stock
SELECT DISTINCT name, mrp 
FROM zepto
WHERE outOfStock = TRUE
ORDER BY mrp DESC;

--Q3. Calculate the Estimated revenue from each caregory
SELECT category, SUM(discountedSellingPrice*availableQuantity) AS total_revenue
FROM zepto
GROUP BY category 
ORDER BY total_revenue DESC;


--Q4. All products with MRP greater then 500 and discount less than 10%
SELECT DISTINCT(name), mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC, discountPercent DESC;

--Q5. Top 5 product categroy offers heighest Average Discount percentage
SELECT category, ROUND(AVG(discountPercent)) AS AverageDiscount
FROM zepto
GROUP BY category
ORDER BY AverageDiscount DESC LIMIT 5;

--Q6. Price Per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice, ROUND(discountedSellingPrice/weightInGms,2) AS Best_value
FROM zepto
WHERE weightInGms >= 100
ORDER BY Best_value;

--Q7. Group Products into weight category like Low, Medium, Bluk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
	WHEN weightInGms < 5000 THEN 'MEDIUM'
	ELSE 'BLUK'
	END AS Weight_Category
FROM zepto;


--Q8. What's total Inventory Weight By category
SELECT DISTINCT category, ROUND(SUM(weightInGms*availableQuantity)/100) AS total_weight_in_kg
FROM zepto
GROUP BY category
ORDER BY total_weight_in_kg;