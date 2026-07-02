-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

WITH days_between AS(
SELECT 
    DATEDIFF(day, customer_nodes.start_date, customer_nodes.end_date) AS days_difference,
    regions.region_name
FROM customer_nodes
INNER JOIN regions
    ON customer_nodes.region_id = regions.region_id
WHERE customer_nodes.end_date != '9999-12-31'
)

SELECT
    DISTINCT region_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_difference) OVER (PARTITION BY region_name) AS median_days,
    PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY days_difference) OVER (PARTITION BY region_name) AS eighty_percentile_days,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days_difference) OVER (PARTITION BY region_name) AS nintyfive_percentile_days
FROM days_between

-- The median and 95th percentile days are identical across all five regions
-- Varies by one day for some regions in the 80th percentile