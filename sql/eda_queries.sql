/* =====================================================
              EXPLORATORY DATA ANALYSIS – 
   ===================================================== */


/* -----------------------------------------------------
   1. DATA OVERVIEW
----------------------------------------------------- */

-- Preview first 10 rows
SELECT *
FROM ikea.products
LIMIT 10;

-- Total number of rows
SELECT COUNT(*) AS total_rows
FROM ikea.products;

-- View table structure
DESCRIBE ikea.products;


/* -----------------------------------------------------
   2. BASIC PRICE STATISTICS
----------------------------------------------------- */

-- Minimum, maximum, and average price
SELECT
    MIN(price) AS cheapest_price,
    MAX(price) AS most_expensive_price,
    ROUND(AVG(price),2) AS average_price
FROM ikea.products;


/* -----------------------------------------------------
   3. CATEGORY EXPLORATION
----------------------------------------------------- */

-- Unique product categories
SELECT DISTINCT category
FROM ikea.products
ORDER BY category;

-- Unique product subcategories
SELECT DISTINCT subcategory
FROM ikea.products
ORDER BY subcategory;


/* -----------------------------------------------------
   4. PRODUCT DISTRIBUTION
----------------------------------------------------- */

-- Number of products per category
SELECT
    category,
    COUNT(*) AS total_products
FROM ikea.products
GROUP BY category
ORDER BY total_products DESC;

-- Number of products per subcategory
SELECT
    subcategory,
    COUNT(*) AS total_products
FROM ikea.products
GROUP BY subcategory
ORDER BY total_products DESC;


/* -----------------------------------------------------
   5. PRICE ANALYSIS BY CATEGORY
----------------------------------------------------- */

-- Average price per category and subcategory
SELECT
    category,
    subcategory,
    ROUND(AVG(price),2) AS avg_price
FROM ikea.products
GROUP BY category, subcategory
ORDER BY avg_price DESC;

-- Price range per category and subcategory
SELECT
    category,
    subcategory,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM ikea.products
GROUP BY category, subcategory
ORDER BY max_price DESC;


/* -----------------------------------------------------
   6. CATEGORY DIVERSITY
----------------------------------------------------- */

-- Number of subcategories within each category
SELECT
    category,
    COUNT(DISTINCT subcategory) AS total_subcategories
FROM ikea.products
GROUP BY category
ORDER BY total_subcategories DESC;


/* -----------------------------------------------------
   7. PRICE DISTRIBUTION
----------------------------------------------------- */

-- Overall product price segmentation
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


/* -----------------------------------------------------
   8. PRICE INSIGHTS
----------------------------------------------------- */

-- Highest priced product within each category and subcategory
SELECT 
    category,
    subcategory,
    MAX(price) AS highest_price
FROM ikea.products
GROUP BY category, subcategory
ORDER BY highest_price DESC;

-- Price segmentation across categories
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
ORDER BY category;


/* -----------------------------------------------------
   9. MOST EXPENSIVE PRODUCTS
----------------------------------------------------- */

-- Top 10 most expensive products
SELECT 
    title,
    category,
    subcategory,
    price
FROM ikea.products
ORDER BY price DESC
LIMIT 10;