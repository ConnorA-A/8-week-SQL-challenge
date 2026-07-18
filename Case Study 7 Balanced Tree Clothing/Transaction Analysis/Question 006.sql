-- What is the average revenue for member transactions and non-member transactions (discounts excluded)

WITH revenues AS(
SELECT
    txn_id,
    SUM(CASE WHEN MEMBER = 1 THEN price * qty END) AS member_revenue,
    SUM(CASE WHEN MEMBER = 0 THEN price * qty END) AS non_member_revenue
FROM sales
GROUP BY txn_id
)

SELECT
    AVG(member_revenue) AS average_member_revenues,
    AVG(non_member_revenue) AS average_non_member_revenues
FROM revenues

