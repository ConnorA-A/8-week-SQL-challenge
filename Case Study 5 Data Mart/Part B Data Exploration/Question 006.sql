-- What is the percentage of sales for Retail vs Shopify for each month?

WITH platform_monthly_sales AS (
SELECT
    month_number,
    SUM(CASE WHEN platform = 'Shopify' THEN CAST(sales AS BIGINT) ELSE 0 END) AS total_shopify_sales,
    SUM(CASE WHEN platform = 'Retail' THEN CAST(sales AS BIGINT) ELSE 0 END) AS total_retail_sales
FROM clean_weekly_sales
GROUP BY month_number
)

SELECT
    platform_monthly_sales.month_number,
    CAST(ROUND((total_shopify_sales * 100.0 / (total_shopify_sales + total_retail_sales)), 2) AS DECIMAL (15, 2)) AS shopify_sales_percentage,
    CAST(ROUND((total_retail_sales *100.0 / (total_shopify_sales + total_retail_sales)), 2) AS DECIMAL (15, 2)) AS retail_sales_percentage
FROM platform_monthly_sales
ORDER BY month_number ASC

-- Retail is concistently 97% to 97.5% of total sales for each month, shopify around 3% - 2.5%