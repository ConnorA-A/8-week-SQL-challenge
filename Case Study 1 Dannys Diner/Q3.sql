-- What was the first item from the menu purchased by each customer?

WITH ranked AS (
    SELECT
        sales.customer_id,
        menu.product_name,
        DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank
    FROM sales
    INNER JOIN menu
        ON sales.product_id = menu.product_id
)

SELECT customer_id, product_name
FROM ranked
WHERE rank =  1


