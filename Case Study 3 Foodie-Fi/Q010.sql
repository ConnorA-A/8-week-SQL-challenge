-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

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

