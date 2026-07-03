-- How many unique nodes are there on the Data Bank system?

SELECT COUNT(DISTINCT node_id) AS distinct_nodes
FROM customer_nodes 

-- There is 3,500 customer nodes assigned in the customer_nodes table.
-- But only 5 unique node IDs exist.