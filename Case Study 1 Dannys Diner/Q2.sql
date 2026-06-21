-- How many days has each customer visited in the restaurant?

SELECT customer_id, COUNT(DISTINCT order_date) AS No_of_days_visited
FROM sales
GROUP BY customer_id

-- Customer B has visited the most often, with 6 visits, Customer A has visited 4 times, and C has visited only twice