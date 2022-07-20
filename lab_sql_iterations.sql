use sakila;

-- Write queries to answer the following questions:

-- 1. Write a query to find what is the total business done by each store.
SELECT s.store_id, SUM(p.amount) as business
FROM staff s
JOIN payment p ON s.staff_id=p.staff_id
GROUP BY s.store_id;


-- 2. Convert the previous query into a stored procedure.
CREATE PROCEDURE business_by_store()
SELECT s.store_id, SUM(p.amount) as business
FROM staff s
JOIN payment p ON s.staff_id=p.staff_id
GROUP BY s.store_id;


-- 3. Convert the previous query into a stored procedure that takes the input for `store_id` and displays the *total sales for that store*.
DELIMITER //
  CREATE PROCEDURE businessbystore (IN Storeid varchar(30))
  BEGIN
SELECT s.store_id, SUM(p.amount) as business
FROM staff s
JOIN payment p ON s.staff_id=p.staff_id
WHERE s.store_id=Storeid
GROUP BY s.store_id;
   END//
DELIMITER ;

CALL businessbystore(2);

-- 4. Update the previous query. Declare a variable `total_sales_value` of float type, that will store the returned result 
-- (of the total sales amount for the store). 
-- Call the stored procedure and print the results.

DROP PROCEDURE IF EXISTS total_sales_store;


DELIMITER //
CREATE PROCEDURE total_sales_store (IN Storeid varchar(30), OUT total_sales_value float)
BEGIN
-- DECLARE total_sales_value FLOAT DEFAULT 0.0; -- ---> I do not understand what is this for (???)
SELECT SUM(p.amount) as business
INTO total_sales_value
FROM staff s
JOIN payment p ON s.staff_id=p.staff_id
WHERE s.store_id=Storeid 
GROUP BY s.store_id;
   END//
DELIMITER ;

CALL total_sales_store(1,@money);

SELECT @money;


-- 5. In the previous query, add another variable `flag`. If the total sales value for the store is over 30.000, then label it as 
-- `green_flag`, otherwise label is as `red_flag`. 
-- Update the stored procedure that takes an input as the `store_id` and returns total sales value for that store and flag value.

DROP PROCEDURE IF EXISTS total_sales_store;


DELIMITER //
CREATE PROCEDURE total_sales_store (IN Storeid varchar(30),OUT total_sales_value float,OUT flag varchar(30))
BEGIN
DECLARE total_sales_value FLOAT DEFAULT 0.0; 
DECLARE flag varchar(40);
SELECT SUM(p.amount) as business -- need to calculate the flag color
INTO total_sales_value -- need to store the flag color
FROM staff s
JOIN payment p ON s.staff_id=p.staff_id
WHERE s.store_id=Storeid 
GROUP BY s.store_id;
IF SUM(p.amount)> 30000 THEN SET flag='green_flag';
ELSE SET flag='red_flag';
END IF;

   END//
DELIMITER ;

CALL total_sales_store(1,@money,@flag_colour);

SELECT @money,@flag_colour;
