-- What is the top selling product for each segment? (quantity sold)

WITH ranking AS(
SELECT
    segment_name,
    product_name,
    SUM(qty) AS total_quantity,
    DENSE_RANK () OVER (PARTITION BY segment_name ORDER BY SUM(qty) DESC) AS rnk
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY product_name, segment_name
)

SELECT
    segment_name, 
    product_name, 
    total_quantity, 
    rnk
FROM ranking
WHERE rnk = 1
ORDER BY total_quantity DESC

