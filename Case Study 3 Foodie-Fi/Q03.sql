-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

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