-- Running customer balance column that includes impact of each transaction

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
    correct_signs.transaction_amount,
    running_balance,
    correct_signs.txn_type,
    correct_signs.txn_date
FROM correct_signs
ORDER BY customer_id, txn_date ASC