-- What is the percentage split of revenue by product for each segment?

WITH revenues AS(
SELECT
    segment_name,
    product_name,
    SUM((qty * sales.price)) AS total_revenue
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY segment_name, product_name
)

SELECT
    segment_name,
    product_name,
    CAST(ROUND(((total_revenue * 100.0)/ SUM(total_revenue) OVER (PARTITION BY segment_name)), 2) AS DECIMAL (15, 2)) AS percentage_split_per_segment
FROM revenues