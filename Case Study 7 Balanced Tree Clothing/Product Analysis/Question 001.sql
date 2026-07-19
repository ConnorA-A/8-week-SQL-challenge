-- What are the top 3 products by total revenue before discount?

SELECT TOP 3
    product_name,
    SUM(sales.price * qty) AS revenue_before_discount
FROM product_details
JOIN sales 
    ON product_details.product_id = sales.prod_id
GROUP BY product_name
ORDER BY SUM(sales.price * qty) DESC
