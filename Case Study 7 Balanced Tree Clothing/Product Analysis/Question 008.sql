-- What is the percentage split of total revenue by category?

WITH revenues AS (
SELECT
    category_name,
    SUM(qty * sales.price) AS revenue
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY category_name
)

SELECT
    category_name,
    CAST(ROUND(((revenue * 100.0)) / SUM(revenue) OVER (), 2) AS DECIMAL (15, 2)) AS percent_split
FROM revenues