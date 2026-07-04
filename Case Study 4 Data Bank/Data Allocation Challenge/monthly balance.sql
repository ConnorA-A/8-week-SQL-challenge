-- Customer balance at end of each month

WITH monthly_balances AS(
SELECT
    customer_transactions.customer_id,
    MONTH(txn_date) AS month_number,
    datename(MONTH, txn_date) AS months,
    CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END AS corrected_sings,
    SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END) OVER (PARTITION BY customer_id ORDER BY MONTH(txn_date)) AS monthly_balance
FROM customer_transactions
)

SELECT
    monthly_balances.customer_id,
    month_number,
    months, 
    monthly_balance
FROM monthly_balances
GROUP BY monthly_balances.customer_id, month_number, months, monthly_balance
ORDER BY monthly_balances.customer_id, month_number ASC

