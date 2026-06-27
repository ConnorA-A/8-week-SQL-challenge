-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT
    DATEPART(month, subscriptions.start_date) AS month_numbers,
    DATENAME(month, subscriptions.start_date) AS month_names,
    COUNT(subscriptions.plan_id) AS trials_in_month
FROM foodie_fi.subscriptions
WHERE subscriptions.plan_id = 0
GROUP BY DATEPART(month, subscriptions.start_date), DATENAME(month, subscriptions.start_date)
ORDER BY DATEPART(month, subscriptions.start_date)

