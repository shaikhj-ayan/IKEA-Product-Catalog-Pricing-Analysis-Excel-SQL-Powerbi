/* =====================================================
                 DATA CLEANING SCRIPT – 
   ===================================================== */


/* -----------------------------------------------------
   1. FIX SCHEMA ISSUES
----------------------------------------------------- */

-- Fix incorrect column name
ALTER TABLE ikea.products
RENAME COLUMN `ï»¿product_id` TO product_id;

-- Convert price column to DECIMAL
ALTER TABLE ikea.products
MODIFY price DECIMAL(10,2);


/* -----------------------------------------------------
   2. CHECK DUPLICATE ROWS
----------------------------------------------------- */

WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
           PARTITION BY title, category, subcategory, price
           ) AS row_num
    FROM ikea.products
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


/* -----------------------------------------------------
   3. CHECK MISSING VALUES
----------------------------------------------------- */

SELECT
    'price' AS column_name,
    SUM(price IS NULL) AS missing_values
FROM ikea.products

UNION

SELECT
    'category',
    SUM(category IS NULL)
FROM ikea.products

UNION

SELECT
    'subcategory',
    SUM(subcategory IS NULL)
FROM ikea.products

UNION

SELECT
    'title',
    SUM(title IS NULL)
FROM ikea.products;


/* -----------------------------------------------------
   4. HANDLE EMPTY OR BLANK VALUES
----------------------------------------------------- */

-- Find empty subcategory rows
SELECT title, category, subcategory
FROM ikea.products
WHERE subcategory = '';

-- Count missing subcategories
SELECT COUNT(*) AS missing_values
FROM ikea.products
WHERE subcategory IS NULL
OR TRIM(subcategory) = '';

-- Remove extra spaces
UPDATE ikea.products
SET subcategory = TRIM(subcategory);

-- Replace missing values
UPDATE ikea.products
SET subcategory = 'Unknown'
WHERE subcategory IS NULL OR subcategory = '';

UPDATE ikea.products
SET category = 'Unknown'
WHERE category IS NULL OR category = '';


/* -----------------------------------------------------
   5. CLEAN TEXT VALUES
----------------------------------------------------- */

-- Remove unnecessary marketing words from titles
UPDATE ikea.products
SET title = REPLACE(REPLACE(title, '- IKEA US', ''), 'New', '');


/* -----------------------------------------------------
   6. FIX ENCODING ISSUES
----------------------------------------------------- */

UPDATE ikea.products
SET title = REPLACE(
                REPLACE(
                    REPLACE(title,'Ã…','Å'),
                'Ã¶','ö'),
            'Ã¸','ø');


/* -----------------------------------------------------
   7. FIX MISSPELLED VALUES
----------------------------------------------------- */

UPDATE ikea.products
SET subcategory = CASE
    WHEN subcategory = 'Wall dÃ©cor'
        THEN 'Wall decor'
    ELSE subcategory
END;


/* -----------------------------------------------------
   8. SPLIT INCORRECT CATEGORY VALUES
----------------------------------------------------- */

-- Fix category values containing '&'
UPDATE ikea.products
SET 
category = TRIM(SUBSTRING_INDEX(category, '&', 1)),
subcategory = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(category, '&', -1), '&', 1))
WHERE category LIKE '%&%'
AND (subcategory IS NULL OR TRIM(subcategory) = '');

-- Fix category values containing ','
UPDATE ikea.products
SET 
category = TRIM(SUBSTRING_INDEX(category, ',', 1)),
subcategory = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(category, ',', -1), ',', 1))
WHERE category LIKE '%,%'
AND (subcategory IS NULL OR TRIM(subcategory) = '');