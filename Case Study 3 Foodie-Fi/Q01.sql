-- How many customers has Foodoe-Fi ever had?

SELECT COUNT(DISTINCT subscriptions.customer_id) AS unique_customers
FROM foodie_fi.subscriptions