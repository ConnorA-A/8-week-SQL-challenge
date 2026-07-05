-- Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?


-- NO we can't as avg_transaction was calculated per row (sales / transactions for that single row entry to the table)

-- The correct approach is to recalculate from raw totals as a weighted average.


SELECT
    calendar_year,
    platform,
    CAST(ROUND(SUM(CAST(sales AS DECIMAL (12, 2))) / SUM(transactions), 2) AS DECIMAL (12, 2)) AS average_transaction_size,
    CAST(ROUND(AVG(avg_transaction), 2) AS DECIMAL (12, 2)) AS incorrect_average
FROM clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform ASC
