# Case Study 4. Data Bank: Customer Transactions

[← Back to main README](../../README.md)

## 1. What is the unique count and total amount for each transaction type?

```sql
SELECT
    txn_type,
    COUNT(txn_type) AS transaction_frequency,
    SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type
```

| txn_type | transaction_frequency | total_amount |
|---|---|---|
| purchase | 1617 | 806537 |
| withdrawal | 1580 | 793003 |
| deposit | 2671 | 1359168 |

## 2. What is the average total historical deposit counts and amounts for all customers?

```sql
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
```

| average_deposits | average_deposited |
|---|---|
| 5 | 2718 |

## 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```sql
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
```

| months | month_num | deposit_and_purchase_or_withdrawal |
|---|---|---|
| January | 1 | 168 |
| February | 2 | 181 |
| March | 3 | 192 |
| April | 4 | 70 |

## 4. What is the closing balance for each customer at the end of the month?

```sql
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
```

| customer_id | months | running_balance | closing_balances |
|---|---|---|---|
| 1 | 1 | 312 | 312 |
| 1 | 3 | -952 | -640 |
| 2 | 1 | 549 | 549 |
| 2 | 3 | 61 | 610 |
| 3 | 1 | 144 | 144 |
| 3 | 2 | -965 | -821 |
| 3 | 3 | -401 | -1222 |
| 3 | 4 | 493 | -729 |
| 4 | 1 | 848 | 848 |
| 4 | 3 | -193 | 655 |
| 5 | 1 | 954 | 954 |
| 5 | 3 | -2877 | -1923 |
| 5 | 4 | -490 | -2413 |
| 6 | 1 | 733 | 733 |
| 6 | 2 | -785 | -52 |
| 6 | 3 | 392 | 340 |
| 7 | 1 | 964 | 964 |
| 7 | 2 | 2209 | 3173 |
| 7 | 3 | -640 | 2533 |
| 7 | 4 | 90 | 2623 |

_(showing 20 of 1720 rows)_

## 5. What is the percentage of customers who increase their closing balance by more than 5%?

```sql
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
```

| increased_closing_balance_customers |
|---|
| 43.78 |
