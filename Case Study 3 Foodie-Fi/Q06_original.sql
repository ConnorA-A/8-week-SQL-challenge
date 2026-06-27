-- What is the number and percentage of customer plans after their initial free trial?

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
    SUM(CASE WHEN ranking.plan_id = 1 THEN 1 ELSE 0 END) AS basic_monthly_after_trial,
    CAST(ROUND(SUM(CASE WHEN ranking.plan_id = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT( DISTINCT ranking.customer_id), 2) AS DECIMAL (4, 1)) AS basic_monthly_percent,
    SUM(CASE WHEN ranking.plan_id = 2 THEN 1 ELSE 0 END) AS pro_monthly_after_trial,
   CAST(ROUND( SUM(CASE WHEN ranking.plan_id = 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT ranking.customer_id), 2) AS DECIMAL (4, 1)) AS pro_monthly_percent,
    SUM(CASE WHEN ranking.plan_id = 3 THEN 1 ELSE 0 END) AS pro_annual_after_trial,
   CAST(ROUND( SUM(CASE WHEN ranking.plan_id = 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT ranking.customer_id), 2) AS DECIMAL (4, 1)) AS pro_annual_percent,
    SUM(CASE WHEN ranking.plan_id = 4 THEN 1 ELSE 0 END) AS churn_after_trial,
  CAST( ROUND( SUM(CASE WHEN ranking.plan_id = 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT ranking.customer_id), 2) AS DECIMAL (4, 1)) AS churned_percent
FROM ranking
WHERE ranking.subscriptions_order = 2

