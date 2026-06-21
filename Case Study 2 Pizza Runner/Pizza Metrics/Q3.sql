-- How many successful orders were delivered by each runner?

SELECT 
    runner_id,
    SUM(CASE
    WHEN cancellation = '' OR cancellation = 'null' OR cancellation  IS     NULL THEN 1
    ELSE 0
    END) AS successful_orders
FROM runner_orders
GROUP BY runner_id
