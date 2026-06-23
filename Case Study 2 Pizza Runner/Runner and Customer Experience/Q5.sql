-- What was the difference between the longest and shortest delivery time for all orders?
WITH difference AS(
SELECT
    runner_orders.order_id,
    ROUND(CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'minutes', ''), 'mins', ''), 'minute', '') AS FLOAT), 2) AS clean_duration
FROM runner_orders
WHERE runner_orders.duration != 'null'
)

SELECT 
    MAX(clean_duration) - MIN(clean_duration) AS diff
FROM difference

