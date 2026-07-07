-- How many cookies does each user have on average?

WITH cookies_per_user AS (
SELECT
    user_id,
    COUNT(cookie_id) * 1.0 AS cookies_held
FROM users
GROUP BY user_id
)

SELECT
    CAST(ROUND(AVG(cookies_held), 2) AS DECIMAL (10, 2)) AS average_cookies
FROM cookies_per_user