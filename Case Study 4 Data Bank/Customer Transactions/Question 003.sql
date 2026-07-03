-- For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

WITH monthly_transactions AS(
SELECT
    customer_transactions.customer_id,
    DATENAME(MONTH, txn_date) AS months,
    MONTH(txn_date) AS month_num,
    SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS total_purchases,
    SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS total_withdrawals
FROM customer_transactions
GROUP BY customer_transactions.customer_id, DATENAME(MONTH, txn_date), MONTH(txn_date)
HAVING  SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) > 1 
AND (SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) >= 1 
OR SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) >= 1)
)

SELECT
    months, 
    month_num,
    COUNT(*) AS deposit_and_purchase_or_withdrawal
FROM monthly_transactions
GROUP BY months, month_num
ORDER BY month_num ASC


-- Customers made more than 1 deposit and purchased or made a withdrawal the most in March, with the least being in April.

