-- What is the item purchased just before the customer became a member?

WITH before AS (
SELECT
    sales.customer_id,
    sales.order_date, 
    menu.product_id,
    menu.product_name,
    members.join_date,
    DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS rank
FROM sales
INNER JOIN members
    ON sales.customer_id = members.customer_id
INNER JOIN menu
    ON sales.product_id = menu.product_id
WHERE sales.order_date < members.join_date
)

SELECT customer_id, product_name, product_id
FROM before
WHERE rank = 1

