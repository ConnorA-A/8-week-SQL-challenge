-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
    customer_id,
    SUM(CASE
            WHEN sales.product_id = 1 THEN menu.price * 20
            ELSE price * 10
        END) AS total_points
FROM sales
INNER JOIN menu 
    ON sales.product_id = menu.product_id
GROUP BY customer_id
