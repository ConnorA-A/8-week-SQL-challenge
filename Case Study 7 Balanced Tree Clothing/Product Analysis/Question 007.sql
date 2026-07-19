-- What is the percentage split of revenue by segment for each category?

WITH segregated AS(
SELECT
    category_name,
    segment_name,
    SUM(sales.price * qty) AS revenue
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY category_name, segment_name
)

SELECT
    category_name,
    segment_name,
    CAST(ROUND(((revenue * 100.0) / SUM(revenue) OVER (PARTITION BY category_name)), 2) AS DECIMAL (15, 2)) AS percentage_split_of_revenue
FROM segregated