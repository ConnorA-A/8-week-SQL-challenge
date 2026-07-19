-- What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
SELECT
    product_name,
    CAST(ROUND(((COUNT(DISTINCT txn_id) * 100.0) / (SELECT COUNT(DISTINCT txn_id) FROM sales)), 2) AS DECIMAL (15, 2)) AS penetration_percent
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY product_name
ORDER BY CAST(ROUND(((COUNT(DISTINCT txn_id) * 100.0) / (SELECT COUNT(DISTINCT txn_id) FROM sales)), 2) AS DECIMAL (15, 2)) DESC