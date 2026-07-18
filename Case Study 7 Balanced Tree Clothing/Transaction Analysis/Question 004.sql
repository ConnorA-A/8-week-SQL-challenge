-- What is the average discount value per transaction?

WITH discounts AS(
SELECT
    txn_id,
    CAST(ROUND(SUM(qty * price * (discount / 100.0)), 2) AS DECIMAL (12, 2)) AS discount_value
FROM sales
GROUP BY txn_id
)

SELECT
    CAST(ROUND(AVG(discount_value), 2) AS DECIMAL (10, 2)) AS average_discount_value_per_transaction
FROM discounts