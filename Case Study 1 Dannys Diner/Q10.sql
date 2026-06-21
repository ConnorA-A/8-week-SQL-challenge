-- In the first week after a customer joins the programme (including their join date) they earn 2x points on all items, not just sushi. How many points do customers A and B have at the end of January?

SELECT
    sales.customer_id,
    SUM(CASE
    WHEN sales.order_date BETWEEN members.join_date AND DATEADD(day, 6, join_date) THEN 10 * 2 * menu.price
    WHEN menu.product_name = 'sushi' THEN 20 * menu.price
    ELSE 10 * menu.price
    END) AS points
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
INNER JOIN members
    ON sales.customer_id = members.customer_id
WHERE sales.order_date <= '2021-01-31'
GROUP BY sales.customer_id
