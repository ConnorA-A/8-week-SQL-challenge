# Case Study 4. Data Bank: Data Allocation Challenge

[← Back to main README](../../README.md)

## 1. Running customer balance column that includes impact of each transaction

```sql
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
```

| customer_id | transaction_amount | running_balance | txn_type | txn_date |
|---|---|---|---|---|
| 1 | 312 | 312 | deposit | 2020-01-02 |
| 1 | -612 | -300 | purchase | 2020-03-05 |
| 1 | 324 | 24 | deposit | 2020-03-17 |
| 1 | -664 | -640 | purchase | 2020-03-19 |
| 2 | 549 | 549 | deposit | 2020-01-03 |
| 2 | 61 | 610 | deposit | 2020-03-24 |
| 3 | 144 | 144 | deposit | 2020-01-27 |
| 3 | -965 | -821 | purchase | 2020-02-22 |
| 3 | -213 | -1034 | withdrawal | 2020-03-05 |
| 3 | -188 | -1222 | withdrawal | 2020-03-19 |
| 3 | 493 | -729 | deposit | 2020-04-12 |
| 4 | 458 | 458 | deposit | 2020-01-07 |
| 4 | 390 | 848 | deposit | 2020-01-21 |
| 4 | -193 | 655 | purchase | 2020-03-25 |
| 5 | 974 | 974 | deposit | 2020-01-15 |
| 5 | 806 | 1780 | deposit | 2020-01-25 |
| 5 | -826 | 954 | withdrawal | 2020-01-31 |
| 5 | -886 | 68 | purchase | 2020-03-02 |
| 5 | 718 | 786 | deposit | 2020-03-19 |
| 5 | -786 | 0 | withdrawal | 2020-03-26 |

_(showing 20 of 5868 rows)_

## 2. minimum, average and maximum values of the running balance for each customer

```sql
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
```

| customer_id | minimum_running_balance | average_running_balance | maximum_running_balance |
|---|---|---|---|
| 1 | -640 | -151 | 312 |
| 2 | 549 | 579 | 610 |
| 3 | -1222 | -732 | 144 |
| 4 | 458 | 653 | 848 |
| 5 | -2413 | -135 | 1780 |
| 6 | -552 | 624 | 2197 |
| 7 | 887 | 2268 | 3539 |
| 8 | -1029 | 173 | 1363 |
| 9 | -91 | 1021 | 2030 |
| 10 | -5090 | -2229 | 556 |
| 11 | -2529 | -1950 | 60 |
| 12 | -647 | -14 | 295 |
| 13 | 379 | 901 | 1444 |
| 14 | 205 | 751 | 989 |
| 15 | 379 | 740 | 1102 |
| 16 | -4284 | -1921 | 421 |
| 17 | -892 | -292 | 465 |
| 18 | -1216 | -539 | 757 |
| 19 | -301 | -41 | 258 |
| 20 | 465 | 783 | 1017 |

_(showing 20 of 500 rows)_

## 3. Customer balance at end of each month

```sql
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
```

| customer_id | month_number | months | monthly_balance |
|---|---|---|---|
| 1 | 1 | January | 312 |
| 1 | 3 | March | -640 |
| 2 | 1 | January | 549 |
| 2 | 3 | March | 610 |
| 3 | 1 | January | 144 |
| 3 | 2 | February | -821 |
| 3 | 3 | March | -1222 |
| 3 | 4 | April | -729 |
| 4 | 1 | January | 848 |
| 4 | 3 | March | 655 |
| 5 | 1 | January | 954 |
| 5 | 3 | March | -1923 |
| 5 | 4 | April | -2413 |
| 6 | 1 | January | 733 |
| 6 | 2 | February | -52 |
| 6 | 3 | March | 340 |
| 7 | 1 | January | 964 |
| 7 | 2 | February | 3173 |
| 7 | 3 | March | 2533 |
| 7 | 4 | April | 2623 |

_(showing 20 of 1720 rows)_
