-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

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
