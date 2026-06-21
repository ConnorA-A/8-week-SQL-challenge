-- Rank all things

WITH information AS (
SELECT 
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    menu.price,
    CASE
        WHEN members.join_date > sales.order_date THEN 'N'
        WHEN members.join_date <= sales.order_date THEN 'Y'
        ELSE 'N' END AS membership
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
LEFT JOIN members
    ON sales.customer_id = members.customer_id)


SELECT *,
CASE
    WHEN membership = 'N' then NULL
    ELSE DENSE_RANK() OVER (PARTITION BY customer_id, membership ORDER BY order_date) END AS ranking
FROM information