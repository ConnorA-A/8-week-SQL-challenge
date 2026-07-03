-- How many days on average are customers reallocated to a different node?

SELECT 
    AVG((DATEDIFF(day, customer_nodes.start_date, customer_nodes.end_date))) AS average_days_between
FROM customer_nodes
WHERE customer_nodes.end_date != '9999-12-31'


-- On average (without the date '9999-12-31), customers are reallocated to a different node in 14 days.