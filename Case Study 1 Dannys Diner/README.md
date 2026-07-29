# Case Study 1. Danny's Diner

[← Back to main README](../README.md)

## 1. What is the total amount each customer spent at the restaurant?

```sql
SELECT customer_id, sum(price) AS Total_spent
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY customer_id
```

| customer_id | Total_spent |
|---|---|
| A | 76 |
| B | 74 |
| C | 36 |

## 2. How many days has each customer visited in the restaurant?

```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS No_of_days_visited
FROM sales
GROUP BY customer_id
```

| customer_id | No_of_days_visited |
|---|---|
| A | 4 |
| B | 6 |
| C | 2 |

## 3. What was the first item from the menu purchased by each customer?

```sql
WITH ranked AS (
    SELECT
        sales.customer_id,
        menu.product_name,
        DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank
    FROM sales
    INNER JOIN menu
        ON sales.product_id = menu.product_id
)

SELECT customer_id, product_name
FROM ranked
WHERE rank =  1
```

| customer_id | product_name |
|---|---|
| A | sushi |
| A | curry |
| B | curry |
| C | ramen |
| C | ramen |

## 4. What is the most purchased item on the menu, and how many times was it purchased by all customers?

```sql
SELECT menu.product_name, COUNT(sales.product_id) AS purchase_frequency
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY purchase_frequency DESC
```

| product_name | purchase_frequency |
|---|---|
| ramen | 8 |
| curry | 4 |
| sushi | 3 |

## 5. Which item was the most popular for each customer?

```sql
WITH popular AS (
    SELECT 
        sales.customer_id, 
        menu.product_name,
        DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY count(sales.product_id) DESC) AS rank
    FROM sales
    INNER JOIN menu
        ON sales.product_id = menu.product_id
    GROUP BY sales.customer_id, menu.product_name 
)

SELECT customer_id, product_name
FROM popular
WHERE rank = 1
```

| customer_id | product_name |
|---|---|
| A | ramen |
| B | sushi |
| B | curry |
| B | ramen |
| C | ramen |

## 6. Which item was purchased first by the customer after they became a member?

```sql
WITH member_orders AS (
SELECT 
    sales.customer_id, 
    sales.order_date, 
    menu.product_name, 
    members.join_date,
    DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
INNER JOIN members
    ON sales.customer_id = members.customer_id
WHERE order_date >= join_date
)

SELECT customer_id, product_name
FROM member_orders
WHERE rank = 1
```

| customer_id | product_name |
|---|---|
| A | curry |
| B | sushi |

## 7. What is the item purchased just before the customer became a member?

```sql
WITH before AS (
SELECT
    sales.customer_id,
    sales.order_date, 
    menu.product_id,
    menu.product_name,
    members.join_date,
    DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS rank
FROM sales
INNER JOIN members
    ON sales.customer_id = members.customer_id
INNER JOIN menu
    ON sales.product_id = menu.product_id
WHERE sales.order_date < members.join_date
)

SELECT customer_id, product_name, product_id
FROM before
WHERE rank = 1
```

| customer_id | product_name | product_id |
|---|---|---|
| A | sushi | 1 |
| A | curry | 2 |
| B | sushi | 1 |

## 8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT 
    sales.customer_id,
    COUNT(sales.product_id) AS total_items,
    SUM(menu.price) AS total_spent
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
INNER JOIN members
    ON sales.customer_id = members.customer_id
WHERE sales.order_date < members.join_date
GROUP BY sales.customer_id
```

| customer_id | total_items | total_spent |
|---|---|---|
| A | 2 | 25 |
| B | 3 | 40 |

## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT 
    customer_id,
    SUM(CASE
            WHEN sales.product_id = 1 THEN menu.price * 20
            ELSE price * 10
        END) AS total_points
FROM sales
INNER JOIN menu 
    ON sales.product_id = menu.product_id
GROUP BY customer_id
```

| customer_id | total_points |
|---|---|
| A | 860 |
| B | 940 |
| C | 360 |

## 10. In the first week after a customer joins the programme (including their join date) they earn 2x points on all items, not just sushi. How many points do customers A and B have at the end of January?

```sql
SELECT
    sales.customer_id,
    SUM(CASE
    WHEN sales.order_date BETWEEN members.join_date AND DATEADD(day, 6, join_date) THEN 10 * 2 * menu.price
    WHEN menu.product_name = 'sushi' THEN 20 * menu.price
    ELSE 10 * menu.price
    END) AS points
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
INNER JOIN members
    ON sales.customer_id = members.customer_id
WHERE sales.order_date <= '2021-01-31'
GROUP BY sales.customer_id
```

| customer_id | points |
|---|---|
| A | 1370 |
| B | 820 |

## Bonus 1. Join all the things

```sql
SELECT 
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    menu.price,
    CASE
        WHEN members.join_date > sales.order_date THEN 'N'
        WHEN members.join_date <= sales.order_date THEN 'Y'
        ELSE 'N' END AS membership
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
LEFT JOIN members
    ON sales.customer_id = members.customer_id
```

| customer_id | order_date | product_name | price | membership |
|---|---|---|---|---|
| A | 2021-01-01 | sushi | 10 | N |
| A | 2021-01-01 | curry | 15 | N |
| A | 2021-01-07 | curry | 15 | Y |
| A | 2021-01-10 | ramen | 12 | Y |
| A | 2021-01-11 | ramen | 12 | Y |
| A | 2021-01-11 | ramen | 12 | Y |
| B | 2021-01-01 | curry | 15 | N |
| B | 2021-01-02 | curry | 15 | N |
| B | 2021-01-04 | sushi | 10 | N |
| B | 2021-01-11 | sushi | 10 | Y |
| B | 2021-01-16 | ramen | 12 | Y |
| B | 2021-02-01 | ramen | 12 | Y |
| C | 2021-01-01 | ramen | 12 | N |
| C | 2021-01-01 | ramen | 12 | N |
| C | 2021-01-07 | ramen | 12 | N |

## Bonus 2. Rank all the things

```sql
WITH information AS (
SELECT 
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    menu.price,
    CASE
        WHEN members.join_date > sales.order_date THEN 'N'
        WHEN members.join_date <= sales.order_date THEN 'Y'
        ELSE 'N' END AS membership
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
LEFT JOIN members
    ON sales.customer_id = members.customer_id)


SELECT *,
CASE
    WHEN membership = 'N' then NULL
    ELSE DENSE_RANK() OVER (PARTITION BY customer_id, membership ORDER BY order_date) END AS ranking
FROM information
```

| customer_id | order_date | product_name | price | membership | ranking |
|---|---|---|---|---|---|
| A | 2021-01-01 | sushi | 10 | N | NULL |
| A | 2021-01-01 | curry | 15 | N | NULL |
| A | 2021-01-07 | curry | 15 | Y | 1 |
| A | 2021-01-10 | ramen | 12 | Y | 2 |
| A | 2021-01-11 | ramen | 12 | Y | 3 |
| A | 2021-01-11 | ramen | 12 | Y | 3 |
| B | 2021-01-01 | curry | 15 | N | NULL |
| B | 2021-01-02 | curry | 15 | N | NULL |
| B | 2021-01-04 | sushi | 10 | N | NULL |
| B | 2021-01-11 | sushi | 10 | Y | 1 |
| B | 2021-01-16 | ramen | 12 | Y | 2 |
| B | 2021-02-01 | ramen | 12 | Y | 3 |
| C | 2021-01-01 | ramen | 12 | N | NULL |
| C | 2021-01-01 | ramen | 12 | N | NULL |
| C | 2021-01-07 | ramen | 12 | N | NULL |
