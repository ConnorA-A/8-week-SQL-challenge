-- How many runners signed up for each 1 week period? (weeks start 2021-01-01)

SELECT 
    DATEDIFF(WEEK, '2021-01-01', runners.registration_date) AS weeks,
    COUNT(runners.runner_id) AS registerations
FROM runners
GROUP BY DATEDIFF(WEEK, '2021-01-01', runners.registration_date)

