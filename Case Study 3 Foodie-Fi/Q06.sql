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
    ranking.plan_name,
    COUNT(*) AS plan_count,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT ranking.customer_id) FROM ranking), 2) AS DECIMAL(4,1)) percentage_of_total
FROM ranking
WHERE subscriptions_order = 2
GROUP BY plan_name
