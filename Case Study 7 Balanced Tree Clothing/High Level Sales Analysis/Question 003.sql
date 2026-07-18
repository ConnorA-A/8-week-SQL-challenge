-- What was the total discount amount for all products?

SELECT
    CAST(ROUND(SUM((qty * price * (discount / 100.0))), 2) AS DECIMAL (12, 2)) AS total_discount_amount
FROM sales