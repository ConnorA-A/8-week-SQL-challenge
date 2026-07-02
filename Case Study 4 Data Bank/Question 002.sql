-- What is the number of nodes per region?

SELECT
    regions.region_name,
    COUNT(DISTINCT customer_nodes.node_id) AS node_ids_per_region
FROM regions
INNER JOIN customer_nodes
    ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name

-- Each region has 5 unique node IDs
