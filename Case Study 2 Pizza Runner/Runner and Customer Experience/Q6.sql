-- What was the average speed for each runner for each delivery? Any trends?

WITH distance_duration AS(
SELECT
    runner_orders.order_id,
    runner_orders.runner_id,
    ROUND(CAST(REPLACE(runner_orders.distance,'km', '') AS FLOAT), 2) AS cleaned_distance,
    ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'minutes', ''), 'mins', ''), 'minute', '') AS FLOAT) / 60), 2) AS cleaned_duration_in_hours
FROM runner_orders
WHERE runner_orders.distance != 'null' AND runner_orders.duration != 'null'
)

SELECT
    runner_id,
    order_id,
    ROUND(cleaned_distance / cleaned_duration_in_hours, 2) AS speed
FROM distance_duration