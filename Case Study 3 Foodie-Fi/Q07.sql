-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
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
