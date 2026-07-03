-- What is the closing balance for each customer at the end of the month?
WITH total_events AS(
SELECT
   customer_transactions.customer_id,
   MONTH(txn_date) AS months,
   CASE WHEN txn_type = 'withdrawal' THEN txn_amount ELSE 0 END AS withdrawals,
   CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END AS deposits,
   CASE WHEN txn_type = 'purchase' THEN txn_amount ELSE 0 END AS purchases
FROM customer_transactions
),

running_balances AS (
SELECT 
    total_events.customer_id,
    months,
    SUM(deposits) - SUM(withdrawals) - SUM(purchases) AS running_balance
FROM total_events
GROUP BY  total_events.customer_id, months
)

SELECT
    running_balances.customer_id,
    running_balances.months,
    running_balance,
    SUM(running_balance) OVER (PARTITION BY customer_id ORDER BY months) AS closing_balances
FROM running_balances
ORDER BY running_balances.customer_id