-- How many customer upgraded to the annual plan in 2020?

SELECT 
    COUNT(subscriptions.plan_id) AS annual_plans
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 3 AND subscriptions.start_date BETWEEN '2020-01-01' AND '2020-12-31'

