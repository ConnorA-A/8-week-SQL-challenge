-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

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
