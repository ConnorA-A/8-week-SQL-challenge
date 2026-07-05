-- What is the percentage of sales by demographic for each year in the dataset?

WITH demographic_sales AS(
SELECT
    calendar_year,
    SUM(CASE WHEN demographic = 'Couples' THEN CAST(sales AS BIGINT) ELSE 0 END) AS couples_sales,
    SUM(CASE WHEN demographic = 'Families' THEN CAST(sales AS BIGINT) ELSE 0 END) AS families_sales,
    SUM(CASE WHEN demographic = 'unknown' THEN CAST(sales AS BIGINT) ELSE 0 END) AS unknown_sales
FROM clean_weekly_sales
GROUP BY calendar_year
)

SELECT
    demographic_sales.calendar_year,
    CAST(ROUND(couples_sales * 100.0 / (couples_sales + families_sales + unknown_sales), 2) AS DECIMAL (15, 2)) AS couples_percentage,
    CAST(ROUND(families_sales * 100.0 / (couples_sales + families_sales + unknown_sales), 2) AS DECIMAL (15, 2)) AS families_percentage,
    CAST(ROUND(unknown_sales * 100.0 / (couples_sales + families_sales + unknown_sales), 2) AS DECIMAL (15, 2)) AS unknown_percentage
FROM demographic_sales
ORDER BY calendar_year ASC

-- Intrestingly unknown is the largest demographic bucket every year and couples is the lowest every year