-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

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