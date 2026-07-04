-- minimum, average and maximum values of the running balance for each customer

WITH correct_signs AS(
SELECT
    customer_transactions.customer_id,
    CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END AS transaction_amount,
    customer_transactions.txn_type,
    customer_transactions.txn_date,
    SUM( CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END) OVER (PARTITION BY customer_id ORDER BY txn_date) AS running_balance
FROM customer_transactions
)

SELECT 
    correct_signs.customer_id,
    MIN(running_balance) AS minimum_running_balance,
    AVG(running_balance) AS average_running_balance,
    MAX(running_balance) AS maximum_running_balance
FROM correct_signs
GROUP BY correct_signs.customer_id
ORDER BY correct_signs.customer_id ASC
