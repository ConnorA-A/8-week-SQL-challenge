-- Which item was the most popular for each customer?

WITH popular AS (
    SELECT 
        sales.customer_id, 
        menu.product_name,
        DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY count(sales.product_id) DESC) AS rank
    FROM sales
    INNER JOIN menu
        ON sales.product_id = menu.product_id
    GROUP BY sales.customer_id, menu.product_name 
)

SELECT customer_id, product_name
FROM popular
WHERE rank = 1