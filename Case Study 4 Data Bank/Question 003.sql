-- How many customers are allocated to each region?

SELECT
    COUNT(DISTINCT customer_nodes.customer_id) AS customers_per_region,
    regions.region_name
FROM customer_nodes
INNER JOIN regions
    ON customer_nodes.region_id = regions.region_id
GROUP BY regions.region_name

-- Australia has the most customers with 110.
-- Europe has the least with 88.