create database fun;
use fun;
create table product
(
	pid int(3) primary key,
    pname varchar(50) not null,
    price int(10) not null,
    stock int(5),
    location varchar(30) check(location in ('Mumbai','Delhi'))
);
describe product;
-- Customer - cid, cname, age, addr
create table customer
(
	cid int(3) primary key,
    cname varchar(30) not null,
    age int(3),
    addr varchar(50)
);

-- Orders - oid, cid, pid, amt
create table orders
(
	oid int(3) primary key,
    cid int(3),
    pid int(3),
    amt int(10) not null,
    foreign key(cid) references customer(cid),
    foreign key(pid) references product(pid)
);


-- Payment - pay_id, oid,amount, mode(upi, cerdit, debit), status
create table payment
(
	pay_id int(3) primary key,
    oid int(3),
    amount int(10) not null,
    mode varchar(30) check(mode in('upi','credit','debit')),
    status varchar(30),
    foreign key(oid) references orders(oid)
);
ALTER TABLE payment
ADD COLUMN timestamp TIMESTAMP;

#Inserting values into products table
insert into product values(1,'HP Laptop',50000,15,'Mumbai');
insert into product values(2,'Realme Mobile',20000,30,'Delhi');
insert into product values(3,'Boat earpods',3000,50,'Delhi');
insert into product values(4,'Levono Laptop',40000,15,'Mumbai');
insert into product values(5,'Charger',1000,0,'Mumbai');
insert into product values(6, 'Mac Book', 78000, 6, 'Delhi');
insert into product values(7, 'JBL speaker', 6000, 2, 'Delhi');
insert into product values(8 , 'Asus Laptop',50000,15,'Delhi');

#Inserting values into customer table
insert into customer values(101,'Ravi',30,'fdslfjl');
insert into customer values(102,'Rahul',25,'fdslfjl');
insert into customer values(103,'Simran',32,'fdslfjl');
insert into customer values(104,'Purvesh',28,'fdslfjl');
insert into customer values(105,'Sanjana',22,'fdslfjl');

#Inserting values into orders table
insert into orders values(10001,102,3,2700);
insert into orders values(10002,104,2,18000);
insert into orders values(10003,105,5,900);
insert into orders values(10004,101,1,46000);

#inserting values into payments table
insert into payment values(1,10001,2700,'upi','completed');
insert into payment values(2,10002,18000,'credit','completed');
insert into payment values(3,10003,900,'debit','in process');
UPDATE payment
SET timestamp = '2024-05-01 08:00:00'
WHERE pay_id = 1;
UPDATE payment
SET timestamp = '2024-05-01 08:10:00'
WHERE pay_id = 2;
UPDATE payment
SET timestamp = '2024-05-01 08:15:00'
WHERE pay_id = 3;


-- SUBQUERIES:-

/* The single-row subquery returns one row. Multiple-row subqueries return sets of rows. 
These queries are commonly used to generate result sets that will be passed to a DML or SELECT statement for further processing. 
Both single-row and multiple-row subqueries will be evaluated once, before the parent query is run. 
"Single-row and multiple-row subqueries can be used in the WHERE and HAVING clauses of the parent query." */

/*CORELATED SUBQUERIES: SQL Correlated Subqueries are used to select data from a table referenced in the outer query.
The subquery is known as a correlated because the subquery is related to the outer query. In this type of queries,
 a table alias (also called a correlation name) must be used to specify which table reference is to be used.*/

-- SINGLE ROW SUBQUERIES:-
-- 1. SELECT Statement with Single-Row Subquery
SELECT cname
FROM customer
WHERE cid = (
    SELECT cid
    FROM orders
    ORDER BY amt DESC
    LIMIT 1
);

#Example 2: Find the product with the highest price
select pname from products 
where price=(select max(price) from products);


-- MULTIPLE-ROW SUBQUERIES

#Example 1: Find all customers who have placed an order
select cname
from customer
where cid in (select cid
from orders);

#Example 2: Find all customers who have placed an order for a product from Madurai
SELECT 
    cname
FROM
    customer
WHERE
    cid IN (SELECT 
            cid
        FROM
            orders
        WHERE
            pid IN (SELECT 
                    pid
                FROM
                    products
                WHERE
                    location = 'Madurai'));

-- CORRELATED SUBQUERIES
SELECT cname
FROM customer c 
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.cid = c.cid
    GROUP BY o.customer_id
    HAVING COUNT(o.oid) > 1
);

#Example 2: Customers with Orders Exceeding Average Order Amount
SELECT cname
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.cid = c.cid
    GROUP BY o.cid
    HAVING AVG(o.amt) > (
        SELECT AVG(amt)
        FROM orders
    )
);


-- we are also gonna study some. types of joins with other functions

#INNER JOIN with subquery :- SQL JOINS are used to combine more than two or more tables together to extract 
#						the useful data from all the tables. In this article, we will discuss INNER JOIN in SQL.

/*Example:-To retrieves the products with their corresponding orders where the product price is greater than 1000.*/
SELECT p.pname, o.oid, o.amt
FROM product p
INNER JOIN (
    SELECT *
    FROM orders
) o ON p.pid = o.pid
WHERE p.price > 1000;


#2. LEFT JOIN with aggregate functions-The LEFT JOIN keyword returns all records from the left table (table1), and the 
#        matching records from the right table (table2). The result is 0 records from the right side, if there is no match.

/*Example - To retrieves all products and their total orders' amounts, even if there are no orders.*/

SELECT p.pname, SUM(o.amt) AS total_orders_amount
FROM products p
LEFT JOIN orders o ON p.pid = o.pid
GROUP BY p.pname;


#3. RIGHT JOIN with date and time functions - The RIGHT JOIN keyword returns all records from the right table (table2),
#  and the matching records from the left table (table1). The result is 0 records from the left side, if there is no match.

/*EXAMPLE:-To retreive all orders and their corresponding payment status and timestamp, even if there is no payment record.*/

SELECT o.oid, o.amt, p.status, p.timestamp
FROM orders o
RIGHT JOIN payment p ON o.oid = p.oid;

-- Analytics functions / Advanced functions

-- 1.Rank
-- RANK() gives a 'rank' to each row within a partition, based on an ordered set. If rows have the same value, they get the same rank. 
-- However, the ranks will have gaps when there are ties.
/*Example- Display rank of products on the basis of price using RANK() FUNCTION*/
SELECT pid, pname, price, RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;

-- > Here, RANK() calculates the rank based on the (by using 'OVER' to tell which column should be considered for ranking) 'price' in descending order.
-- > As, you can see both 'HP Laptop' and 'Asus Dryer' has same 'price', thus they were given same rank
-- > However, The rank 3 was skipped due to two rows having same 'price'
-- > Therefore,
-- -- 1. If two products have the same 'price', they share the same rank. 
-- -- 2. and, the next rank will skip the gap to account for the tie.




#2. DENSE_RANK
-- DENSE_RANK() is similar to RANK(), but it does not create gaps when there are ties. 
-- Rows with the same value will get the same rank, but the next rank will be consecutive.
/*Example- Display rank of products on the basis of price using DENSE_RANK() FUNCTION*/
SELECT pid, pname, price, 
	DENSE_RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;

-- > It is similar to RANK() in structure however, 
-- > As, you can see both 'HP laptop' and 'Asus Laptop' has same performace score, thus they were given same rank
-- > However, this time rank 3 was not skipped. 
-- > Therefore,
-- -- 1. If two products have the same 'price', they share the same rank. 
-- -- 2. and, the next rank will not be skipped.




#3. ROW_NUMBER
-- ROW_NUMBER() assigns a unique row number to each record in a partitioned or ordered set. 
-- This always gives unique numbers, even if there are ties.
/*EXAMPLE- Find Unique Row number of the Customer table  using Row number Fuction*/

SELECT ROW_NUMBER() OVER (ORDER BY age DESC) AS row_num, cid, cname, age, addr
FROM customer;

-- AS you can see, ROW_NUMBER() assigns unique numbers to each row, even if the 'age' is the same.
-- It guarantees no duplicates, making it useful for identifying rows uniquely.


#4. CUME_DIST
--  It shows the relative position of a row within a data set, indicating what fraction of the data set is at or below a particular value.
-- The value is always between 0 and 1.
-- The values which will have be closer to 0 will have better score and thus will be identified as being in top percentages

/*Example:-Find Cumulative Distribution of payment done based on amount spend*/
SELECT oid, amount,
       CUME_DIST() OVER (ORDER BY amount) AS cumulative_distribution
FROM payment;
-- > the cumulative distribution is approximately 0.3333333333333333, meaning that approximately 33.33% of payments have an amount less than or equal to 900.
-- -- 1. This value of 0.3333 suggests that 33.33% of payments have an amount less than or equal to 900.
-- -- 2. This value of 0.6666 suggests that 66.66% of payments have an amount less than or equal to 2700.
-- -- 3. This value of 1 suggests that 100% of payments have an amount less than or equal to 18000.
#5. LAG
-- The LAG() function provides access to a row at a specified physical offset prior to the current row within the partition.
-- It's often used to retrieve values from a previous row in the result set without using a self-join.
-- for example, you might use LAG() to retrieve the value of the previous row's amount.

/*EXAMPLE- FIND LAG OF PRICE FROM PRODUCTS TABLE */

SELECT pname, price, location,LAG(price) OVER (PARTITION BY location ORDER BY price) AS lag_price
FROM products;

-- 4. LEAD
-- The LEAD() function provides access to a row at a specified physical offset after the current row within the partition.
-- It's useful for fetching values from subsequent rows in the result set without a self-join.
-- For instance, you could use LEAD() to get the value of the next row's amount.

/*EXAMPLE-FIND LEAD PRICE OF THE PRODUCTS FROM PRODUCTS TABLE*/
SELECT pname, price, location,LEAD(price) OVER (PARTITION BY location ORDER BY price) AS lead_price
FROM products;
/*TIME FOR QUESTIONS*/
-- SUBQUERIES
# Question 1: Find the name of the customer who placed the order with the highest total amount.  
SELECT cname 
FROM customer 
WHERE cid = (
    SELECT cid 
    FROM orders 
    GROUP BY cid 
    ORDER BY SUM(amt) DESC 
    LIMIT 1
);
# Question 2: Retrieve the names of all customers who have placed orders for products located in the same city as the customer named "Rahul". 
SELECT cname
FROM customer
WHERE cid IN (
    SELECT DISTINCT cid
    FROM orders
    WHERE pid IN (
        SELECT pid
        FROM products
        WHERE location = (
            SELECT location
            FROM customer
            WHERE cname = 'Rahul'
        )
    )
);
# Question 3: Retrieve the names of all customers who have placed orders for products that have a price higher than the average price of products bought by each customer.
SELECT cname
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    JOIN products p ON o.pid = p.pid
    WHERE o.cid = c.cid
    AND p.price > (
        SELECT AVG(price)
        FROM products
        WHERE pid IN (
            SELECT pid
            FROM orders
            WHERE cid = c.cid
        )
    )
);
-- JOINS
# Question 4: Retrieve the names of customers who have placed orders for products with a price higher than the average price of all products in the same city as the customer, and also display the total amount spent by each customer on such orders.
SELECT c.cname, SUM(o.amt) AS total_amount_spent
FROM customer c
INNER JOIN orders o ON c.cid = o.cid
INNER JOIN products p ON o.pid = p.pid
INNER JOIN (
    SELECT location, AVG(price) AS avg_price
    FROM products
    GROUP BY location
) avg_prices ON p.location = avg_prices.location
WHERE p.price > avg_prices.avg_price
GROUP BY c.cname;

# Question 5: Retrieve the names of all customers along with the total amount they have spent on orders, including customers who have not placed any orders yet.
SELECT c.cname, COALESCE(SUM(o.amt), 0) AS total_amount_spent
FROM customer c
LEFT JOIN orders o ON c.cid = o.cid
GROUP BY c.cname;

# Question 6: Retrieve all customer details along with their corresponding order details, even if there are no corresponding orders, and display 'No order' instead of NULL. If there are no corresponding orders, also display the reason for no order (e.g., 'Out of stock').
SELECT c.cid,
       c.cname,
       c.age,
       c.addr,
       CASE 
           WHEN o.oid IS NULL THEN 'No order'
           ELSE o.oid
       END AS order_id,
       CASE 
           WHEN o.oid IS NULL THEN 'No order'
           ELSE p.status
       END AS order_status
FROM customer c
LEFT JOIN orders o ON c.cid = o.cid
RIGHT JOIN payment p ON o.oid = p.oid
ORDER BY c.cid;


-- Advance Functions
# Question 7: Retrieve the names of products along with their prices and the ranking of each product based on their prices, where the products are ranked in descending order of price.

SELECT pname, price, RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;


# Question 8: Retrieve the names of products along with their prices and the dense ranking of each product based on their prices, where products are ranked in descending order of price.

SELECT pname, price, DENSE_RANK() OVER (ORDER BY price DESC) AS dense_price_rank
FROM products;

# Question 9: Retrieve the names of products along with their prices and the row number of each product, where products are ordered by their prices in descending order.

SELECT pname, price, ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num
FROM products;

# Question 10: Retrieve the names of products along with their prices and the cumulative distribution of each product's price, indicating what fraction of products have prices less than or equal to the price of each product.
SELECT pname, price, CUME_DIST() OVER (ORDER BY price) AS cumulative_distribution
FROM products;

# Question 11:  Retrieve the names of products along with their prices and the price of the previous product in the list, ordered by price in ascending order.
SELECT pname, price, LAG(price) OVER (ORDER BY price) AS previous_price
FROM products;

# Question 12:  Retrieve the names of products along with their prices and the price of the next product in the list, ordered by price in ascending order.
SELECT pname, price, LEAD(price) OVER (ORDER BY price) AS next_price
FROM products;
