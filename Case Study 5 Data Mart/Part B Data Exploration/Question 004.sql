-- What is the total sales for each region for each month?


SELECT
    month_number,
    region,
    SUM(CAST(sales AS BIGINT)) AS total_regional_sales
FROM clean_weekly_sales
GROUP BY month_number, region
ORDER BY month_number, region ASC

