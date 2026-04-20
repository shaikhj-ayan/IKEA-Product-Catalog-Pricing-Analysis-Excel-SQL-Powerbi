-- ============================================================
--                  ANALYSIS QUERIES (SQL)
-- ============================================================

-- 1. Identifying the "Flagship" (most expensive) product
SELECT title, price 
FROM ikea.products 
ORDER BY price DESC 
LIMIT 1;


-- 2. Catalog density by category
SELECT category, COUNT(*) as volume
FROM ikea.products 
GROUP BY category 
ORDER BY volume DESC;


-- 3. Top 10 Premium Tier items (High-end outliers)
SELECT 
    title, 
    price 
FROM ikea.products 
ORDER BY price DESC 
LIMIT 10;


-- 4. Top 10 Entry-level items (Loss leaders/Budget)
SELECT 
    title, 
    price 
FROM ikea.products 
ORDER BY price ASC 
LIMIT 10;


-- 5. Average pricing per category (Sorted by premium level)
SELECT 
    category, 
    AVG(price) as avg_unit_price
FROM ikea.products 
GROUP BY category 
ORDER BY avg_unit_price DESC;


-- 6. Market Positioning: Identifying High-End vs Affordable categories
SELECT 
    category,
    AVG(price) as cat_avg,
    COUNT(*) as sku_count,
    IF(AVG(price) > (SELECT AVG(price) FROM ikea.products), 'High-End', 'Affordable') as segment
FROM ikea.products
GROUP BY category
ORDER BY cat_avg DESC;


-- 7. Price gap analysis: Restaurant vs Grocery food items
SELECT 
    MAX(CASE WHEN category LIKE '%restaurant%' THEN price END) - 
    MAX(CASE WHEN category = 'IKEA Food' THEN price END) as food_price_delta
FROM ikea.products
WHERE category IN ('IKEA Food & Swedish restaurant', 'IKEA Food');


-- 8. Global Inventory Distribution by Price Tier
SELECT 
    CASE 
        WHEN price < 500 THEN 'Budget'
        WHEN price < 2000 THEN 'Mid-Tier'
        WHEN price < 5000 THEN 'Premium'
        ELSE 'Luxury' 
    END as tier,
    COUNT(*) as count
FROM ikea.products 
GROUP BY tier
ORDER BY MIN(price);


-- 9. Subcategory deep-dive: Granular pricing levels
SELECT 
    category, 
    subcategory,
    COUNT(*) as skus,
    ROUND(AVG(price)) as avg_price
FROM ikea.products
GROUP BY category, subcategory
ORDER BY category, avg_price DESC;
