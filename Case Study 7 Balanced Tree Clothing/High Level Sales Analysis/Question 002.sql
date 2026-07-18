-- What is the total generated revenue for all products before discounts?

SELECT
    SUM(qty * price) AS total_revenue
FROM sales