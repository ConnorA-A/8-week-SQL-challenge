-- What are the 25th, 50th and 75th percentile values for the revenue per transaction (discounts excluded)

WITH revenue_data AS(
SELECT
    txn_id,
    CAST(ROUND(SUM(qty * price), 2) AS DECIMAL (15, 2)) AS total_revenue
FROM sales
GROUP BY txn_id
)

SELECT TOP 1
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue) OVER () AS twentyfifth_percentile,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_revenue) OVER () AS fifty_percentile,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue) OVER () AS seventyfifth_percentile
FROM revenue_data