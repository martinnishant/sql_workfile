show databases;
use flipkart;
-- Group by using having
SELECT cname, COUNT(*) AS Number
FROM customer
GROUP BY cname
HAVING Number >= 1;

-- Group by using concat
SELECT location, GROUP_CONCAT(DISTINCT pname) AS product_names
FROM products
GROUP BY location;

-- C) GROUP BY can also be used while using aggregate function like COUNT, MAX, MIN, AVG, SUM
-- by count
SELECT category, COUNT(*) as total_sales
FROM sales
GROUP BY category;

-- by sum
SELECT category, SUM(amount) as total_amount
FROM sales
GROUP BY category;

-- by avg
SELECT category, AVG(amount) as average_amount
FROM sales
GROUP BY category;

-- by min and max
SELECT category, MAX(amount) as max_amount, MIN(amount) as min_amount
FROM sales
GROUP BY category;




-- ORDER BY x
-- x can be any datatype
SELECT * FROM employees
ORDER BY salary;

-- B) ASCENDING
SELECT pid, pname, price
FROM products
ORDER BY price ASC;

-- C) DESCENDING
SELECT cid, cname, age
FROM customer
ORDER BY age DESC;

-- Having by 
-- Examples
SELECT 
    Salesperson, 
    SUM(Amount) AS TotalSales
FROM 
    Sales
GROUP BY 
    Salesperson
HAVING 
    SUM(Amount) > 10000;
    
SELECT 
    CustomerID, 
    COUNT(OrderID) AS OrderCount
FROM 
    Orders
GROUP BY 
    CustomerID
HAVING 
    COUNT(OrderID) > 5;
    

-- GROUP BY:
-- 1) Write a query to find the total stock of products for each location.
SELECT location, SUM(stock) AS total_stock 
FROM products 
GROUP BY location;

-- 2) Write a query to find the number of products in each price range (e.g., 0-10000, 10000-20000, 20000-50000, 50000+).
SELECT CASE 
 WHEN price BETWEEN 0 AND 10000 THEN '0-10000' 
 WHEN price BETWEEN 10001 AND 20000 THEN '10000-20000'
 WHEN price BETWEEN 20001 AND 50000 THEN '20000-50000' 
 ELSE '50000+' 
 END AS price_range, COUNT(*) AS product_count
 FROM products 
 GROUP BY price_range;
-- 3) Write a query to find the average age of customers grouped by their location (based on the address).
SELECT SUBSTRING(addr, 1, 3) AS location, AVG(age) AS avg_age 
FROM customer 
GROUP BY location;
-- ORDER BY:
-- 1) Write a query to retrieve all products ordered by their price in descending order.
SELECT * 
FROM products 
ORDER BY price DESC;
-- 2) Write a query to retrieve all customers ordered by their age in ascending order.
SELECT * 
FROM customer 
ORDER BY age ASC;
-- 3) Write a query to retrieve all orders ordered by the order amount in descending order and then by the customer name in ascending order.
SELECT o.oid, c.cname, o.amt 
FROM orders o 
JOIN customer c ON o.cid = c.cid 
ORDER BY o.amt DESC, c.cname ASC;
-- HAVING:
-- 1) Write a query to find the locations where the total stock of products is greater than 20.
SELECT location, SUM(stock) AS total_stock 
FROM products 
GROUP BY location 
HAVING SUM(stock) > 20;
-- 2) Write a query to find the customers who have placed orders with a total amount greater than 10000.
SELECT c.cid, c.cname, SUM(o.amt) AS total_amount 
FROM customer c 
JOIN orders o ON c.cid = o.cid 
GROUP BY c.cid, c.cname 
HAVING SUM(o.amt) > 10000;
-- 3) Write a query to find the products that have a stock level between 10 and 20 and are located in Mumbai.
SELECT p.pid, p.pname, p.stock 
FROM products p 
WHERE p.location = 'Mumbai' 
GROUP BY p.pid, p.pname, p.stock 
HAVING p.stock BETWEEN 10 AND 20;


-- DQL (Select)

-- A) SELECT With DISTINCT Clause
SELECT DISTINCT cname,addr FROM customer;

-- B) SELECT all columns(*)
SELECT * FROM orders;

-- C) SELECT by column name
SELECT oid FROM orders;

-- D) SELECT with LIKE(%)
-- a) "Ra" anywhere
SELECT * FROM customer WHERE cname LIKE "%Ra%";

-- b) Begins With "Ra"
SELECT * FROM customer WHERE cname LIKE "Ra%";

-- a) Ends With "vi
SELECT * FROM customer WHERE cname LIKE "%vi";

-- E) SELECT with CASE or IF
-- a) CASE
SELECT cid,
	   cname,
       CASE WHEN cid > 102 THEN 'Pass' ELSE 'Fail' END AS 'Remark'
FROM customer;
-- b) IF
SELECT cid,
	   cname,
       IF(cid > 102, 'Pass', 'Fail')AS 'Remark'
FROM customer;

-- F) SELECT with a LIMIT Clause
SELECT * 
FROM customer
ORDER BY cid
LIMIT 2;

-- G) SELECT with WHERE
SELECT * FROM customer WHERE cname = "Ravi";


-- 1) Write a query to retrieve the distinct locations of products from the products table
SELECT DISTINCT location 
FROM products;
-- 2) Write a query to retrieve the customer ID, customer name, and the length of their address as address_length from the customer table.
SELECT cid, cname, LENGTH(addr) AS address_length
FROM customer;  
-- 3) Write a query to retrieve the order ID, customer name, product name, and the concatenated string 'Order for [product name] by [customer name]' as order_description from the orders, customer,and products tables.
SELECT o.oid, c.cname, p.pname, CONCAT('Order for ', p.pname, ' by ', c.cname) AS order_description
FROM orders o
JOIN customer c ON o.cid = c.cid
JOIN products p ON o.pid = p.pid;
-- 4) Write a query to retrieve the product ID, product name, price, and a new column price_category that categorizes the products based on their price range (e.g., 'Low' for prices less than 10000, 'Medium' for prices between 10000 and 50000, and 'High' for prices greater than 50000).
SELECT pid, pname, price,
       CASE
           WHEN price < 10000 THEN 'Low'
           WHEN price BETWEEN 10000 AND 50000 THEN 'Medium'
           ELSE 'High'
       END AS price_category
FROM products;
-- 5) Write a query to retrieve the customer ID, customer name, and the total order amount for each customer. The total order amount should be retrieved from a subquery that calculates the sum of order amounts for eachcustomer.
SELECT c.cid, c.cname, (
    SELECT SUM(amt)
    FROM orders o
    WHERE o.cid = c.cid
) AS total_order_amount
FROM customer c;
