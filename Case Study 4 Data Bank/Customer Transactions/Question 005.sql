-- What is the percentage of customers who increase their closing balance by more than 5%?

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
),

closing_balance AS (
SELECT
    running_balances.customer_id,
    running_balances.months,
    running_balance,
    SUM(running_balance) OVER (PARTITION BY customer_id ORDER BY months) AS closing_balances
FROM running_balances
),

ranking AS (
SELECT
    closing_balance.customer_id,
    FIRST_VALUE(closing_balances) OVER (PARTITION BY customer_id ORDER BY months ASC) AS first_balance,
    FIRST_VALUE(closing_balances) OVER (PARTITION BY customer_id ORDER BY months DESC) AS last_balance
FROM closing_balance
),

percentage_change AS (
SELECT 
    ranking.customer_id,
    CAST(ROUND((((last_balance - first_balance) * 100.0) / first_balance), 2) AS DECIMAL(10, 2)) AS increase_closing_balance_percent
FROM ranking
),

percent_customers AS(
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN increase_closing_balance_percent > 5.00 THEN 1 ELSE 0 END) AS greaterthan_five_percent_customers
FROM percentage_change

)

SELECT
    CAST(ROUND((greaterthan_five_percent_customers * 100.0 / total_customers), 2) AS DECIMAL(12, 2)) AS increased_closing_balance_customers
FROM percent_customers

-- 43.78% of customer have increased their closing balance by more then 5%.
-- This means 56.22% of customers have not increased their closing balance by 5%.