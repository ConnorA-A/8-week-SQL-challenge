-- What is the most purchased item on the menu, and how many times was it purchased by all customers?

SELECT menu.product_name, COUNT(sales.product_id) AS purchase_frequency
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY purchase_frequency DESC
