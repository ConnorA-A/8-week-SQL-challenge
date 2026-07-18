-- What is the average unique products purchased in each transaction?

WITH required_data AS(
SELECT
    txn_id,
    COUNT(DISTINCT prod_id) AS unique_products_per_transaction
FROM sales
GROUP BY txn_id
)

SELECT
    AVG(unique_products_per_transaction) AS average_unique_products_each_transaction
FROM required_data
