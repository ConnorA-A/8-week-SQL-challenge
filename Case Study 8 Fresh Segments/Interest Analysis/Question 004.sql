-- Does this decision make sense to remove these data points from a business perspective? 
-- Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.


-- Using a 14 month id from question 1, we can show the effect this may have.

-- For ths purpose, ID 10008 has been selected

SELECT
    * 
FROM interest_metrics
WHERE (interest_id = 10008) AND (interest_id != 'NULL')
ORDER BY month_year ASC;

-- ID 133 has been selected as an example of one of the removed rows in question 3

SELECT
    * 
FROM interest_metrics
WHERE (interest_id = 133) AND (interest_id != 'NULL')
ORDER BY month_year ASC

-- From the query result, we can see that id 133 doesn't provide us enough data to spot any meaningful trends/insights.
-- Therefore entries like this just provide noise
-- Therefore, removing interest with fewer than 6 months is a reasonable trade-off