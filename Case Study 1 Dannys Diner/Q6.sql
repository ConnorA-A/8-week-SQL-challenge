-- Which item was purchased first by the customer after they became a member?
WITH member_orders AS (
SELECT 
    sales.customer_id, 
    sales.order_date, 
    menu.product_name, 
    members.join_date,
    DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
INNER JOIN members
    ON sales.customer_id = members.customer_id
WHERE order_date >= join_date
)

SELECT customer_id, product_name
FROM member_orders
WHERE rank = 1