-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS customer_thoughts
CREATE TABLE customer_thoughts (
    "order_id" INTEGER,
    "runner_id" INTEGER,
    "rating"  INTEGER CHECK (rating BETWEEN 1 AND 5),
    "rating_time" DATETIME,
    "comments" VARCHAR(500)
);

INSERT INTO customer_thoughts
    (order_id, runner_id, rating, rating_time, comments)
VALUES
    (1, 1, 3, '2021-01-01 20:05:42', 'Delivery took a long time and the pizza was cold'),
    (2, 1, 4, '2021-01-01 21:07:55', 'Delivery was quicker than expected and the driver was very polite'),
    (3, 1, 5, '2021-01-03 01:30:12', 'Exceptional service!'),
    (4, 2, 2, '2021-01-04 14:59:01', 'Delivery took a very long time!'),
    (5, 3, NULL, NULL, NULL)


