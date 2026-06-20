-- Q1 What is the the total amount each customer spent at the restaurant?

SELECT customer_id, sum(price) AS Total_spent
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY customer_id

-- Customer A is the highest spending customer with B slightly behind. Customer C spent the least, less than half of what the other customers spent