-- What is the average total historical deposit counts and amounts for all customers?

WITH per_customer AS(
SELECT
    customer_transactions.customer_id,
    COUNT(txn_type) AS deposits_per_customer,
    SUM(txn_amount) AS average_amount_deposited
FROM customer_transactions
WHERE txn_type = 'deposit'
GROUP BY customer_transactions.customer_id
)

SELECT
    AVG(deposits_per_customer) AS average_deposits,
    AVG(average_amount_deposited) AS average_deposited
FROM per_customer

-- On average customers make 5 deposits in total and deposit roughly 2,718