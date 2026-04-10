-- ============================================================
--                  ANALYSIS QUERIES (SQL)
-- ============================================================

-- 1. What is the most expensive product in the dataset?
SELECT
	title,
	price
FROM ikea.products
ORDER BY price DESC
LIMIT 1;

-- 2. Which category has the highest number of products?
SELECT
	category,
	COUNT(*) AS total_products
FROM ikea.products
GROUP BY category
ORDER BY total_products DESC;

-- 3. What are the top 10 most expensive products?
SELECT
	title,
	price
FROM ikea.products
ORDER BY price DESC
LIMIT 10;

-- 4. What are the 10 cheapest products?
SELECT
	title,
	price
FROM ikea.products
ORDER BY price ASC
LIMIT 10;

-- 5. What is the average price of products in each category?
SELECT
	category,
	ROUND(AVG(price), 2) AS avg_price
FROM ikea.products
GROUP BY category
ORDER BY avg_price DESC;

-- 6. Which categories are high-end vs affordable based on average price?
WITH category_stats AS (
SELECT
	category,
	AVG(price) AS avg_price,
	MAX(price) AS max_price,
	COUNT(*) AS total_products
FROM ikea.products
GROUP BY category
),
overall_avg AS (
SELECT AVG(price) AS overall_avg_price
FROM ikea.products
)
SELECT
	c.category,
	ROUND(c.avg_price, 2) AS avg_price,
	c.max_price,
	c.total_products,
	CASE
		WHEN c.avg_price > o.overall_avg_price THEN 'High-End'
		ELSE 'Affordable'
		END AS category_type
FROM category_stats c
CROSS JOIN overall_avg o
ORDER BY c.avg_price DESC;

-- 7. What is the price difference between the highest priced items in
--    'IKEA Food & Swedish restaurant' and 'IKEA Food' categories?
WITH highest_price AS (
SELECT
	category,
	MAX(price) AS max_price
FROM ikea.products
WHERE category IN ('IKEA Food & Swedish restaurant','IKEA Food')
GROUP BY category
)
SELECT
	ABS(
	MAX(CASE WHEN category = 'IKEA Food & Swedish restaurant' THEN max_price END) -
	MAX(CASE WHEN category = 'IKEA Food' THEN max_price END)
	) AS price_difference
FROM highest_price;

-- 8. How are products distributed across different price segments?
SELECT
	CASE
		WHEN price < 500 THEN 'Cheap'
		WHEN price BETWEEN 500 AND 2000 THEN 'Mid Range'
		WHEN price BETWEEN 2000 AND 5000 THEN 'Premium'
		ELSE 'Luxury'
	END AS price_category,
	COUNT(*) AS total_products
FROM ikea.products
GROUP BY price_category
ORDER BY total_products DESC;

-- 9. How does price segmentation vary across categories and subcategories?
SELECT
	category,
	subcategory,
	CASE
		WHEN price < 500 THEN 'Low'
		WHEN price BETWEEN 500 AND 2000 THEN 'Medium'
		WHEN price BETWEEN 2000 AND 5000 THEN 'High'
		ELSE 'Luxury'
		END AS price_level,
	COUNT(*) AS product_count
FROM ikea.products
GROUP BY category, subcategory, price_level
ORDER BY category, product_count DESC;

-- 10. What is the price range (min, max, range) within each category?
SELECT
	category,
	MIN(price) AS min_price,
	MAX(price) AS max_price,
	ROUND(MAX(price) - MIN(price), 2) AS price_range
FROM ikea.products
GROUP BY category
ORDER BY price_range DESC;

-- 11. How are categories positioned based on product volume and pricing?
SELECT
	category,
	COUNT(*) AS total_products,
	ROUND(AVG(price), 2) AS avg_price,
	CASE
		WHEN COUNT(*) > 1000 AND AVG(price) < 3000 THEN 'Mass Market'
		WHEN COUNT(*) > 1000 AND AVG(price) >= 3000 THEN 'Strong Premium'
		WHEN COUNT(*) <= 1000 AND AVG(price) >= 3000 THEN 'Premium Niche'
		ELSE 'Low Impact'
	END AS category_position
FROM ikea.products
GROUP BY category
ORDER BY total_products DESC;

-- 12. Which subcategories have the highest average prices?
SELECT
	subcategory,
	ROUND(AVG(price), 2) AS avg_price
	FROM ikea.products
GROUP BY subcategory
ORDER BY avg_price DESC
LIMIT 10;
