-- What is the average percentage split of all transactions for members vs non-members?

WITH member_vs_non AS(
SELECT
    COUNT(CASE WHEN member = 1 THEN txn_id END) member_sales,
    COUNT(CASE WHEN member = 0 THEN txn_id END) non_member_sales
FROM sales
)

SELECT
    CAST(ROUND(((member_sales * 100.0) / (member_sales + non_member_sales)), 2) AS DECIMAL (15, 2)) AS member_transactions_percent,
    CAST(ROUND(((non_member_sales * 100.0) / (member_sales + non_member_sales)), 2) AS DECIMAL (15, 2)) AS non_member_transactions_percent
FROM member_vs_non