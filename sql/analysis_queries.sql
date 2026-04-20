-- ============================================================
--                  ANALYSIS QUERIES (SQL)
-- ============================================================


-- 1. Find the single most expensive item
SELECT title, price 
FROM ikea.products 
ORDER BY price DESC 
LIMIT 1;


-- 2. Count how many items are in each category
SELECT category, COUNT(*) as total_items
FROM ikea.products 
GROUP BY category 
ORDER BY total_items DESC;


-- 3. List the 10 most expensive items
SELECT 
    title, 
    price 
FROM ikea.products 
ORDER BY price DESC 
LIMIT 10;


-- 4. List the 10 cheapest items
SELECT 
    title, 
    price 
FROM ikea.products 
ORDER BY price ASC 
LIMIT 10;


-- 5. Average price for every category
SELECT 
    category, 
    AVG(price) as average_price
FROM ikea.products 
GROUP BY category 
ORDER BY average_price DESC;


-- 6. Label categories as above or below the overall average price
SELECT 
    category,
    AVG(price) as category_avg,
    COUNT(*) as item_count,
    CASE 
        WHEN AVG(price) > (SELECT AVG(price) FROM ikea.products) THEN 'Expensive' 
        ELSE 'Affordable' 
    END as price_group
FROM ikea.products
GROUP BY category
ORDER BY category_avg DESC;


-- 7. Difference in price between the top Restaurant item and top Food item
SELECT 
    MAX(CASE WHEN category LIKE '%restaurant%' THEN price END) - 
    MAX(CASE WHEN category = 'IKEA Food' THEN price END) as price_diff
FROM ikea.products
WHERE category IN ('IKEA Food & Swedish restaurant', 'IKEA Food');


-- 8. Group all products into price buckets
SELECT 
    CASE 
        WHEN price < 500 THEN 'Under 500'
        WHEN price < 2000 THEN '500 to 2000'
        WHEN price < 5000 THEN '2000 to 5000'
        ELSE 'Over 5000' 
    END as price_range,
    COUNT(*) as item_count
FROM ikea.products 
GROUP BY price_range
ORDER BY MIN(price);


-- 9. Breakdown of prices by category and subcategory
SELECT 
    category, 
    subcategory,
    COUNT(*) as item_count,
    AVG(price) as average_price
FROM ikea.products
GROUP BY category, subcategory
ORDER BY category, average_price DESC;
