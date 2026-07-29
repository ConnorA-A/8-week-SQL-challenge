# Case Study 3. Foodie-Fi

[← Back to main README](../README.md)

## 1. How many customers has Foodie-Fi ever had?

```sql
SELECT COUNT(DISTINCT subscriptions.customer_id) AS unique_customers
FROM foodie_fi.subscriptions
```

| unique_customers |
|---|
| 1000 |

## 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
SELECT
    DATEPART(month, subscriptions.start_date) AS month_numbers,
    DATENAME(month, subscriptions.start_date) AS month_names,
    COUNT(subscriptions.plan_id) AS trials_in_month
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 0
GROUP BY DATEPART(month, subscriptions.start_date), DATENAME(month, subscriptions.start_date)
ORDER BY DATEPART(month, subscriptions.start_date)
```

| month_numbers | month_names | trials_in_month |
|---|---|---|
| 1 | January | 88 |
| 2 | February | 68 |
| 3 | March | 94 |
| 4 | April | 81 |
| 5 | May | 88 |
| 6 | June | 79 |
| 7 | July | 89 |
| 8 | August | 88 |
| 9 | September | 87 |
| 10 | October | 79 |
| 11 | November | 75 |
| 12 | December | 84 |

## 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
SELECT
    plans.plan_id,
    plans.plan_name,
    COUNT(*) AS total_subscriptions
FROM foodie_fi.subscriptions
INNER JOIN foodie_fi.plans
    ON subscriptions.plan_id = plans.plan_id
WHERE subscriptions.start_date >= '2021-01-01'
GROUP BY plans.plan_id, plans.plan_name
ORDER BY plans.plan_id ASC
```

| plan_id | plan_name | total_subscriptions |
|---|---|---|
| 1 | basic monthly | 8 |
| 2 | pro monthly | 60 |
| 3 | pro annual | 63 |
| 4 | churn | 71 |

## 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
WITH churned AS(    
SELECT
    COUNT(DISTINCT customer_id) AS total_ids,
    SUM(CASE WHEN subscriptions.plan_id = 4 THEN 1 ELSE 0 END) AS total_churned
FROM foodie_fi.subscriptions
)

SELECT 
    churned.total_churned,
    CAST(ROUND(churned.total_churned * 100.0 / churned.total_ids, 1) AS DECIMAL(4, 1)) AS percentage_churned
FROM churned
```

| total_churned | percentage_churned |
|---|---|
| 307 | 30.7 |

## 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
WITH ranking AS(
SELECT
    subscriptions.customer_id,
    subscriptions.plan_id,
    subscriptions.start_date,
    ROW_NUMBER() OVER (PARTITION BY subscriptions.customer_id ORDER BY subscriptions.start_date) AS number_of_subscriptions
FROM foodie_fi.subscriptions
)


SELECT
    SUM(CASE WHEN ranking.number_of_subscriptions = 2 AND plan_id = 4 THEN 1 ELSE 0 END) AS trial_then_churned,
    CAST(ROUND(SUM(CASE WHEN ranking.number_of_subscriptions = 2 AND plan_id = 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT ranking.customer_id), 0) AS INTEGER) AS percentage_trial_then_churned
FROM ranking
WHERE ranking.number_of_subscriptions <= 2
```

| trial_then_churned | percentage_trial_then_churned |
|---|---|
| 92 | 9 |

## 6. What is the number and percentage of customer plans after their initial free trial?

```sql
WITH ranking AS(
SELECT
    subscriptions.customer_id,
    subscriptions.plan_id,
    plans.plan_name,
    ROW_NUMBER () OVER (PARTITION BY subscriptions.customer_id ORDER BY subscriptions.start_date) AS subscriptions_order
FROM foodie_fi.subscriptions
INNER JOIN foodie_fi.plans
    ON subscriptions.plan_id = plans.plan_id
)

SELECT 
    ranking.plan_name,
    COUNT(*) AS plan_count,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT ranking.customer_id) FROM ranking), 2) AS DECIMAL(4,1)) percentage_of_total
FROM ranking
WHERE subscriptions_order = 2
GROUP BY plan_name
```

| plan_name | plan_count | percentage_of_total |
|---|---|---|
| churn | 92 | 9.2 |
| pro annual | 37 | 3.7 |
| basic monthly | 546 | 54.6 |
| pro monthly | 325 | 32.5 |

## 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```sql
WITH current_plans AS(
SELECT 
    subscriptions.customer_id,
    subscriptions.plan_id,
    plans.plan_name,
    ROW_NUMBER() OVER (PARTITION BY subscriptions.customer_id ORDER BY subscriptions.start_date DESC) AS most_recent_plan
FROM foodie_fi.subscriptions
INNER JOIN foodie_fi.plans
    ON subscriptions.plan_id = plans.plan_id
WHERE subscriptions.start_date <= '2020-12-31'
)

SELECT 
    current_plans.plan_name,
    current_plans.plan_id,
    COUNT(*) AS plan_count,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT( DISTINCT subscriptions.customer_id) FROM foodie_fi.subscriptions), 2) AS DECIMAL (4, 1)) AS percent_of_total
FROM current_plans
WHERE most_recent_plan = 1
GROUP BY current_plans.plan_name, current_plans.plan_id
ORDER BY current_plans.plan_id
```

| plan_name | plan_id | plan_count | percent_of_total |
|---|---|---|---|
| trial | 0 | 19 | 1.9 |
| basic monthly | 1 | 224 | 22.4 |
| pro monthly | 2 | 326 | 32.6 |
| pro annual | 3 | 195 | 19.5 |
| churn | 4 | 236 | 23.6 |

## 8. How many customers upgraded to the annual plan in 2020?

```sql
SELECT 
    COUNT(subscriptions.plan_id) AS annual_plans
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 3 AND subscriptions.start_date BETWEEN '2020-01-01' AND '2020-12-31'
```

| annual_plans |
|---|
| 195 |

## 9. How many days on average does it take for a customer to upgrade to an annual plan from the day they join Foodie-Fi?

```sql
WITH trial_collected AS(
SELECT *
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 0 
),

annual_collected AS(
SELECT *
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 3
)


SELECT
    AVG(DATEDIFF(day, trial_collected.start_date, annual_collected.start_date)) AS days_between_upgrade
FROM trial_collected
JOIN annual_collected
    ON trial_collected.customer_id = annual_collected.customer_id
```

| days_between_upgrade |
|---|
| 104 |

## 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```sql
WITH trial_collected AS(
SELECT *
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 0 
),

annual_collected AS(
SELECT *
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 3
)


SELECT
    DATEDIFF(day, trial_collected.start_date, annual_collected.start_date) / 30  AS thirty_day_periods,
    COUNT(DATEDIFF(day, trial_collected.start_date, annual_collected.start_date) / 30 ) AS frequency
FROM trial_collected
JOIN annual_collected
    ON trial_collected.customer_id = annual_collected.customer_id
GROUP BY DATEDIFF(day, trial_collected.start_date, annual_collected.start_date) / 30
```

| thirty_day_periods | frequency |
|---|---|
| 0 | 48 |
| 1 | 25 |
| 2 | 33 |
| 3 | 35 |
| 4 | 43 |
| 5 | 35 |
| 6 | 27 |
| 7 | 4 |
| 8 | 5 |
| 9 | 1 |
| 10 | 1 |
| 11 | 1 |

## 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
WITH following_plan AS(
SELECT
    subscriptions.customer_id,
    subscriptions.plan_id,
    LEAD(subscriptions.plan_id) OVER (PARTITION BY subscriptions.customer_id ORDER BY subscriptions.start_date) AS followed_by
FROM foodie_fi.subscriptions
WHERE subscriptions.start_date BETWEEN '2020-01-01' AND '2020-12-31'
)

SELECT
    COUNT (*) AS downgraded_pro_basic
FROM following_plan
WHERE followed_by = 1
AND plan_id = 2
```

| downgraded_pro_basic |
|---|
| 0 |
