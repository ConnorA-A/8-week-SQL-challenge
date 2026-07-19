-- What is the total quantity, revenue and discount for each segment?

SELECT
    segment_name,
    SUM(qty) AS total_quantity,
    SUM((sales.price * qty)) AS total_revenue,
    CAST(ROUND(SUM((qty * sales.price * (discount / 100.0))), 2) AS DECIMAL (15, 2)) AS total_discount
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
group by segment_name