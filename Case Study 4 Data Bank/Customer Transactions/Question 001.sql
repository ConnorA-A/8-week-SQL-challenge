-- What is the unique count and total amount for each transaction type?

SELECT
    txn_type,
    COUNT(txn_type) AS transaction_frequency,
    SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type

-- Deposits is the most frequent type of transaction and also equals the greatest total amount. 
-- Withdrawal is the lowest frequency with the lowest total amount.