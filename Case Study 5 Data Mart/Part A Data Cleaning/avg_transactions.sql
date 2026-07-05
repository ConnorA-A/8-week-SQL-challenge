-- average test


SELECT
    sales,
    transactions,
    CAST(ROUND((sales * 1.0/ transactions), 2) AS DECIMAL(15, 2)) AS avg_transaction
FROM weekly_sales
