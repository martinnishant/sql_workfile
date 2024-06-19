-- here we are going to study joins in sql 
-- Joins are used to combine two or more tables to get specific data/information
-- there are 6 types of join in sql
#1. Inner Join
#2. Left Outer Join
#3. Right Outer Join
#4. Full Outer Join
#5. Self Join
#6. Cross Join

show databases;
create database earbuds;
drop database flipkart;
use earbuds;

-- creating a table Products -pid, pname, price, stock, location (delhi or Agra)

create table Products(
	pid int(5) primary key,
    pname varchar(50) not null,
    price int(3) not null,
    stock int(3),
    location varchar(30) check(location in ('delhi','Agra'))
);
-- Creating table Customer - cid, cname, age, addr
create table customer
(
	cid int(3) primary key,
    cname varchar(30) not null,
    age int(3),
    addr varchar(50)
);

-- Creating table Orders - oid, cid, pid, amt
create table orders
(
	oid int(3) primary key,
    cid int(3),
    pid int(3),
    amt int(10) not null,
    foreign key(cid) references customer(cid),
    foreign key(pid) references products(pid)
);


-- Creating table Payment - pay_id, oid,amount, mode(upi, cerdit, debit), status
create table payment
(
	pay_id int(3) primary key,
    oid int(3),
    amount int(10) not null,
    mode varchar(30) check(mode in('upi','credit','debit')),
    status varchar(30),
    foreign key(oid) references orders(oid)
);

#Creating table employee - eid, ename, phone_no., department, manager_id
CREATE TABLE employee(
eid INT(4) PRIMARY KEY,
ename VARCHAR(40) NOT NULL,
phone_no INT(10) NOT NULL,
department VARCHAR(40) NOT NULL,
manager_id INT(4)
);

#Inserting values into products table
insert into products values(1,'HP Laptop',50000,15,'Mumbai');
insert into products values(2,'Realme Mobile',20000,30,'Delhi');
insert into products values(3,'Samsung earpods',3000,50,'Delhi');
insert into products values(4,'Levono Laptop',40000,15,'Mumbai');
insert into products values(5,'Ev Charger',1000,0,'Mumbai');
insert into products values(6, 'Mac Book pro', 78000, 6, 'Delhi');
insert into products values(7, 'Marshal speaker', 6000, 2, 'Delhi');

#Inserting values into customer table
insert into customer values(101,'Ravi',30,'fdsfkh');
insert into customer values(102,'Rahul',25,'hadfajl');
insert into customer values(103,'Simran',32,'fdhfhsfjl');
insert into customer values(104,'Purvesh',28,'fdxcvj');
insert into customer values(105,'Sanjana',22,'qwewretgfh');

#Inserting values into orders table
insert into orders values(10001,102,3,2700);
insert into orders values(10002,104,2,18000);
insert into orders values(10003,105,5,900);
insert into orders values(10004,101,1,46000);


#inserting values into payments table
insert into payment values(1,10001,2700,'upi','completed');
insert into payment values(2,10002,18000,'credit','completed');
insert into payment values(3,10003,900,'debit','in process');

#Inserting into employee table
INSERT INTO employee VALUES (401, "Rohan", 364832549, "Analysis", 404);
INSERT INTO employee VALUES (402, "Rahul", 782654123, "Delivery", 406);
INSERT INTO employee VALUES (403, "Shyam", 856471235, "Delivery", 402);
INSERT INTO employee VALUES (404, "Neha", 724863287, "Sales", 402);
INSERT INTO employee VALUES (405, "Sanjana", 125478954, "HR", 404);
INSERT INTO employee VALUES (406, "Sanjay", 956478535, "Tech",null);

#displaying details of products table
SELECT * FROM products;

#displaying details of customer table
SELECT * FROM customer;

#displaying details of orders table
SELECT * FROM orders;

#displaying details of payment table
SELECT * FROM payment;

#Displaying details of employee table
SELECT * FROM employee;

#1.Inner Join -> only matching value from both tables will be present
# for example: For getting the name of customers who placed the order, we need to inner join customer and orders table

SELECT customer.cid, cname, orders.oid FROM orders 
Inner join customer ON orders.cid = customer.cid;

#example2: now getting the name of the customers and products that were ordered, we need to inner join orders, products and customer table

SELECT customer.cid, cname, products.pid, pname, oid FROM orders
inner join products ON orders.pid = products.pid
inner join customer on orders.cid = customer.cid;


#2. Left Outer Join-> All the rows from the left table should be present and matching rows from the right table are present
#example: Getting the product id, product name, amount to be paid in an order, we need to left join products and orders table

SELECT products.pid, pname, amt, orders.oid FROM products
left join orders on orders.pid = products.pid;

#3. Right Join-> All the rows from the right table should be present and only matching rows from the left table are present 
#example: Displaying order details in paymnets table, we need to right join payment and orders table
SELECT * FROM payment 
right join orders on orders.oid = payment.oid;
 
#4.Full Join-> All the rows from both the table should be present 
#Note:- MySQL does not support full join we need to perform "UNION" operation between the results obtained from left and right join
#example: Displaying the details of all the orders and products, we need to full join orders and products tables 

SELECT orders.oid, products.pid, pname, amt, price, stock, location FROM orders
LEFT JOIN products ON orders.pid = products.pid
UNION
SELECT orders.oid, products.pid, pname, amt, price, stock, location FROM orders
RIGHT JOIN products ON orders.pid = products.pid;
 

#5.Self Join-> It is a regular join, but the table is joined by itself
#example: Displaying the employees with managers, we need to self join the employee table 

SELECT e1.ename AS Employee, e2.ename AS Manager FROM employee e1
inner join employee e2 ON e1.manager_id = e2.eid;


#6.Cross Join-> It is used to view all the possible combinations of the rows of one table and with all the rows from second table
#example: Displaying all the details of customer and orders where amount is less than 3000, we need to cross join customer and orders table

SELECT customer.cid, cname, orders.oid, amt FROM customer
CROSS JOIN orders ON customer.cid = orders.cid
WHERE amt > 3000;


-- some other examples base on joins in sql 
-- inner join
SELECT employees.name, departments.name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

-- left outer join
SELECT employees.name, departments.name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;

-- right outer join
SELECT employees.name, departments.name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;

-- full outer join 
SELECT employees.name, departments.name
FROM employees
FULL JOIN departments ON employees.department_id = departments.id;

-- cross join 
SELECT employees.name, departments.name
FROM employees
CROSS JOIN departments;

-- self join 

SELECT e1.name AS Employee, e2.name AS Manager
FROM employees e1
INNER JOIN employees e2 ON e1.manager_id = e2.id;


# ***************************************************** Practice Questions *******************************************
# provide in sheet

#q1. Display details of all orders which were delivered from "Mumbai"

SELECT * FROM orders 
LEFT JOIN products ON orders.pid = products.pid
WHERE location = "Mumbai";

#q2. Display details of all orders whose payment was made through "UPI"

SELECT * FROM orders
RIGHT JOIN payment ON orders.oid = payment.oid
WHERE mode = "UPI";

#q3. Dispaly oid, amt, cname, payment mode of orders which were made by people below 30 years

SELECT orders.oid, cname, amt, mode FROM orders
INNER JOIN payment ON orders.oid = payment.oid
INNER JOIN customer ON orders.cid = customer.cid
WHERE age < 30;

#q4. Dispaly oid, amt, cname, paymentmode of orders which were made by people below 30 years and payment was made through "Credit"

SELECT orders.oid, cname, amt, mode FROM orders
INNER JOIN payment ON orders.oid = payment.oid
INNER JOIN customer ON orders.cid = customer.cid
WHERE age < 30 AND mode = "Credit";

#q5. Display oid, amount, cname, pname, location of the orders whose payment is still pending or in process

SELECT orders.oid, cname, pname, amount, status, location FROM orders
CROSS JOIN products ON orders.pid = products.pid
CROSS JOIN customer ON orders.cid = customer.cid
CROSS JOIN payment ON orders.oid = payment.oid
WHERE status IN ("in process", "pending");

#q6. We have order table, want to also display details of product ordered and details of customer who placed the order

SELECT orders.cid, cname, pname FROM orders
INNER JOIN customer ON orders.cid = customer.cid
INNER JOIN products ON orders.pid = products.pid;


#----------------------------------------Normalisation----------------------------------------------------

-- ANOMLIES
 -- Anomalies are undesirable conditions in a relational database that can lead to data inconsistency, which can lead to data manipulation.
 -- Insertion Anomalies: Occur when you cannot insert valid data due to the structure of the table.
-- Deletion Anomalies: Occur when deleting a row also deletes unrelated data.
-- Update Anomalies: Occur when updating a value in one row requires changes in other rows to maintain consistency, potentially leading to errors.
 
 
 -- Update anomaly
-- Imagine a situation where the price of the "HP Laptop" (ProductID: 1) needs to be updated from ₹50,000 to ₹52,000. Here's the potential update anomaly:

UPDATE Products
SET price = 52000
WHERE pid = 1;

-- DELETE ANOMALY
-- Imagine a situation where a specific product, the "Charger" (ProductID: 5), becomes discontinued and needs to be removed from the database. Here's how a delete anomaly could occur:

-- You delete the "Charger" record from the Products table:

DELETE FROM Products
WHERE pid = 5;



-- The problem arises if there are existing orders for the "Charger" in the Orders table. Deleting the product from Products would leave those orders referencing a non-existent product.


-- INSERTION ANOMALY

-- Imagine you want to create a new order for a customer (CustomerID: 106) who hasn't been added to the Customers table yet. Here's how an insertion anomaly could occur:


INSERT INTO Orders (OrderID, CustomerID, ProductID, Quantity)
VALUES (10005, 106, 2, 1);  -- Assuming ProductID 2 is 'Realme Mobile'

-- The insertion fails because the CustomerID (106) doesn't exist in the Customers table.

-- Candidate Keys
-- Candidate keys are attributes or combinations of attributes within a relation (table) that uniquely identify each tuple (row).
-- They are essential for maintaining data integrity and enforcing constraints within a database schema

-- Creation of a Primary Key
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT
);

-- adding primary key to pre existing table
alter table employees
add primary key (id);

-- deleting primary key from pre existing table
alter table employees
drop primary key;


-- creating a forign key 
CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Adding Foreign key to an already existing table
alter table employees
add foreign key(id) references employees(id);

-- droing a forign key from an already existing table
alter table employees drop foreign key id;

-- (((((((((((((((Normalization))))))))))))))))

/*NORMALISATION
Normalization is the process of minimizing redundancy from a relation or set of relations.
Redundancy in relation may cause insertion, deletion, and update anomalies. So, it helps to minimize the redundancy in relations. 
Normal forms are used to eliminate or reduce redundancy in database tables. 
*/

-- there are some certain types of normalisation
-- First Normal Form (1NF)
-- Second Normal Form (2NF)
-- Third Normal Form (3NF)
-- Boyce-Codd Normal Form (BCNF)


-- 1NF - FIRST NORMAL FORM
-- It is a basic level of data organization in relational databases. It ensures a table structure that minimizes redundancy and improves data integrity.
-- A Table is in 1NF if:
-- -> There are only single valued attributes (atomic values)
-- -> No repeating groups
-- example of 1nf
SELECT student_id, student_name, course_name
FROM students
ORDER BY student_id, course_name;

-- 2nf - second normal form
/*This table adheres to 1NF by:
-> Having atomic values in each cell (single piece of data)
-> Not containing any repeating groups
*/

-- 2NF (Second Normal Form):

/* ->Table must be in 1NF.
-> All non-key attributes (columns) must depend on the entire primary key.
-> If a table has a composite primary key, each non-key attribute must depend on the entire composite key, not just on part of it.
-> If any non-key attribute depends on only a part of a composite key, it violates 2NF and should be moved to a separate table along with the part of the key it depends on.


-> Example Violating 2NF:

Imagine you want to capture additional information about the product purchased in an order, such as its color. Let's modify the Orders table to include a product_color attribute:

Before (Violating 2NF):

OrderID	CustomerID	ProductID	Amount	ProductColor (New Attribute)
10001	102				3		2700				Blue
10002	104				2		18000				Black
10003	105				5		900					White
10004	101				1		46000				Silver


Problem: The product_color attribute depends solely on the ProductID, not the entire primary key of Orders (assuming OrderID is the primary key). This creates a partial dependency.

Solution (Following 2NF):

Introduce a separate Order_Items table to link specific products with their corresponding orders and include product-specific details:

Orders table:

| OrderID (primary key) | CustomerID | ProductID (foreign key) | Amount |

Order_Items table:

| OrderItemID (primary key) | OrderID (foreign key) | ProductID (foreign key) | ProductColor |

Now, product_color relies on the complete primary key (combination of OrderID and ProductID) in the Order_Items table, satisfying 2NF.


3NF (Third Normal Form):

-> Table must be in 2NF.
-> No transitive dependencies should exist.
-> Every non-key attribute must depend on the primary key, and only the primary key.
-> If a non-key attribute depends on another non-key attribute, it should be moved to a separate table along with the attribute it depends on.
*/
-- Example Violating 3NF:

-- Let's consider adding a customer_city attribute to the Orders table:

-- Before (Violating 3NF):

/* OrderID	CustomerID	ProductID	Amount	CustomerCity (New Attribute)
10001			102			3		2700		Delhi
10002			104			2		18000		Mumbai
10003			105			5		900			Delhi
10004			101			1		46000		Mumbai

drive_spreadsheet
Export to Sheets
Problem: The customer_city attribute depends on the customer_id, not the entire primary key of Orders. This creates a transitive dependency. Even though customer_id is a foreign key, it's not the direct determinant of city information.

Solution (Following 3NF):

Leverage the existing relationship between Orders and Customer tables. There's no need to duplicate customer_city in the Orders table. Retrieve city information by joining Orders with Customer using the customer_id foreign key.

By understanding these concepts and potential violations, you can design a more efficient and normalized database schema for future data growth and modifications.


-- BCNF
-- Boyce-Codd Normal Form (BCNF) is a higher level of normalization than 3NF.
-- It eliminates some anomalies that can arise from non-trivial functional dependencies in 3NF relations.

-- Functional Dependency (FD):
-- A functional dependency exists when one attribute uniquely determines another attribute in a relation.

-- Non-Trivial Functional Dependency:
-- A functional dependency is non-trivial if the determining attribute is not a superkey.

-- Key and Superkey:
-- A superkey is a set of attributes that, taken collectively, uniquely identifies a tuple in a relation.
-- A key is a minimal superkey, meaning no proper subset of the key can uniquely identify a tuple.

--  Requirements for BCNF:
-- Every non-trivial functional dependency X → Y, X must be a superkey.
-- No non-trivial functional dependencies should exist between attributes that are not part of some candidate key.

-- Benefits:
-- BCNF ensures that the database is free from update anomalies, insertion anomalies, and deletion anomalies, thus maintaining data integrity.

-- Example: 
-- Funcional dependencies in order table:
-- oid → {cid, pid, amt} (oid uniquely determines cid, pid, and amt)
-- {cid, pid} → {oid, amt} (a combination of cid and pid uniquely determines oid and amt)
-- Candidate Keys: {oid}, {cid, pid}

-- Check for Violation:
-- From the functional dependency {cid, pid} → {oid, amt},
-- we can see that {cid, pid} is not a superkey because cid and pid are not individually unique.
-- Thus, the table violates BCNF.

-- Decomposition:
-- We need to decompose the table into two tables to remove the violation.
-- Table 1: order_info(oid, amt)
-- Table 2: order_details(oid, cid, pid)

-- order_info table
create table order_info
(
	oid int(3) primary key,
    amt int(10) not null,
    foreign key(oid) references orders(oid)
);

-- order_details table
create table order_details
(
	oid int(3),
    cid int(3),
    pid int(3),
    primary key(oid, cid, pid),
    foreign key(oid) references orders(oid),
    foreign key(cid) references customer(cid),
    foreign key(pid) references products(pid)
);
-- Since we have decomposed based on the functional dependency, the original functional dependencies are preserved.


-- QUESTIONS AND ANSWERS
-- ANOMALIES
-- What are potential data anomalies that could occur if the database is not normalized (specifically 1NF, 2NF, or 3NF)?
-- Answer:  Data anomalies are inconsistencies or redundancies that can arise in a non-normalized database. These anomalies can lead to data integrity issues, making it difficult to insert, update, or delete data accurately.

			Insertion Anomaly: Difficulty inserting complete data due to missing dependencies.
			Deletion Anomaly: Deleting data from one table can unintentionally affect data in another table.
			Updation Anomaly: Updating data in one table might require repetitive changes in other tables to maintain consistency.


-- 2. Candidate Keys and Primary Key:

Query: Write a query to display the product information and choose the most appropriate attribute(s) as the primary key for the Products table. Justify your choice.
-- ANSWER: 
SELECT pid, pname, price, stock, location
FROM Products;

-- 3. Foreign Keys:


Query: Write a query that joins the Orders and Customer tables using the foreign key relationship. This query should retrieve order details (order ID, customer name, product ID) for a specific customer (e.g., customer ID 102).
ANSWER: 

SELECT o.oid, c.cname, o.pid
FROM Orders o
INNER JOIN Customer c ON o.cid = c.cid
WHERE o.cid = 102;

4. Normalization Levels (1NF, 2NF, 3NF):

Question: Describe the key differences between 1NF, 2NF, and 3NF.

Answer:

Normalization
1NF - First Normal Form
-> Multivalued attr should not be present
-> Primary key is present in the table
-> Repeating groups
-> Duplicate rows should not be there

2NF - Second Normal Form
-> Should be in 1NF
-> No partial dependency - 
All non key attr should be completely dependent
on primary key 
3NF 
Table must be in 2NF.
-> No transitive dependencies should exist.
-> Every non-key attribute must depend on the primary key, and only the primary key.
-> If a non-key attribute depends on another non-key attribute, it should be moved to a separate table along with the attribute it depends on.


 Boyce-Codd Normal Form (BCNF):

Question: How does BCNF differ from 3NF? When is it typically used?

BCNF (Boyce-Codd Normal Form) is a higher level of normalization compared to 3NF. It addresses a specific type of redundancy that 3NF might not eliminate.

Key Differences:

Dependency Rule:

3NF: Eliminates transitive dependencies where a non-key attribute relies on another non-key attribute.
BCNF: Every determinant (attribute or set of attributes that determines another attribute) in a table must be a candidate key. This ensures there are no hidden dependencies beyond the primary key.
Strictness: BCNF is stricter than 3NF, requiring an additional condition for eliminating certain types of redundancies.
*/
-- 2nf query examples
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    date_of_birth DATE,
    address VARCHAR(255)
);

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100),
    department VARCHAR(100)
);

-- 3nf query examples
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);



