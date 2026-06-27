-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

WITH churned AS(    
SELECT
    COUNT(DISTINCT customer_id) AS total_ids,
    SUM(CASE WHEN subscriptions.plan_id = 4 THEN 1 ELSE 0 END) AS total_churned
FROM foodie_fi.subscriptions
)

SELECT 
    churned.total_churned,
    CAST(ROUND(churned.total_churned * 100.0 / churned.total_ids, 1) AS DECIMAL(4, 1)) AS percentage_churned
FROM churned