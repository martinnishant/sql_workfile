create database flipkart;
use flipkart;
DROP TABLE IF EXISTS poil;
create table poil
(
	pid int(3) primary key,
    pname varchar(50) not null,
    price int(10) not null,
    stock int(5),
    location varchar(30) check(location in ('Maddras','Agra'))
);
create table customer
(
	cid int(3) primary key,
    cname varchar(30) not null,
    age int(3),
    address varchar(50)
);
create table orders
(
	oid int(3) primary key,
    cid int(3),
    pid int(3),
    amt int(10) not null,
    foreign key(cid) references customer(cid),
    foreign key(pid) references products(pid)
);
create table payment
(
	pay_id int(3) primary key,
    oid int(3),
    amount int(10) not null,
    mode varchar(30) check(mode in('upi','credit','debit')),
    status varchar(30),
    foreign key(oid) references orders(oid)
);
-- to delete table we gonna use that line
drop table poil ;
-- use to drop whole database
drop database flipkart;
-- by using alter command we can add and modify the tables 
-- to add column in a table 
alter table customer
add phone varchar(10);

-- to delete a column 
alter table customer
drop column phone;

-- to rename column amt to money
alter table orders
rename column amt to money ;
 
-- to modify datatype or add conditions
alter table products
modify column price varchar(10) ;

alter table products
modify column location varchar(30) check(location in ('Madras','agra' , 'delhi')) ;

-- TURNCATE uses:-
-- The TRUNCATE TABLE command deletes the data inside a table, but not the table itself. only data deleted not whole table
truncate table products ;

-- implementation
alter table customer
modify column age int(7) not null;

alter table customer
modify column phone varchar(10) unique ;

alter table payment
modify column status varchar(30) check( status in ('pending' , 'cancelled' , 'completed'));

alter table products
modify column location varchar(30) default 'Mumbai' check(location in ('Madras','Dalhausi' , 'chennai')) ;

-- implementation
#Inserting values into products table
insert into products values(1,'HP Laptop',50000,16,'Madurai');
insert into products values(2,'Realme Mobile',20000,30,'Dalhausi');
insert into products values(3,'Apple earpods',30000,50,'Delhi');
insert into products values(4,'Levono Laptop',40000,15,'Masurii');
insert into products values(5,'Charger',1000,0,'Mumbai');
insert into products values(6, 'Mac Book pro', 78000, 6, 'Delhi');
insert into products values(7, 'JBL speaker', 6000, 2, 'Delhi');

#Inserting values into customer table
insert into customer (cid, cname, age, addr) values
(101,'Rahul',30,'ergh'),
(102,'Rahul',25,'ewrtyuj'),
(103,'Shyaam',32,'tyuee'),
(104,'Purv jha',28,'ertyu'),
(105,'Sanjana',22,'fdslfjl');

#Inserting values into orders table
insert into orders values(101,1002,3,2700);
insert into orders values(102,1004,2,1800);
insert into orders values(103,0005,5,9000);
insert into orders values(104,1001,1,46000);


#inserting values into payments table
insert into payment values(1,10001,2700,'upi','completed');
insert into payment values(2,10002,18000,'credit','completed');
insert into payment values(3,10003,900,'debit','in process');

update product
set locaiton = 'chennai'
where pname = 'Mac Book pro' ;

delete from customer
where cname = 'Rahul';





-- QUESTIONS
-- 0)Make a new table employee with specified column id, name, position and salary.
CREATE TABLE employee (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary INT NOT NULL
);

--  insert  query adds a new row to the employees table with specific values for id, name, position, and salary.
INSERT INTO employees (id, name, position, salary)
VALUES (1, 'Joe biden', 'American precident', 7500000);

-- update query updates the salary of the employee with id = 1.
UPDATE employees
SET salary = 847310
WHERE id = 1;

-- delete query deletes the row from employees where id = 1.
DELETE FROM employees
WHERE id = 1;

--  create a query that creates a table called students with various constraints.
CREATE TABLE students (
  stu_id INT PRIMARY KEY,       
  name VARCHAR(100) NOT NULL,        
  email VARCHAR(100) UNIQUE,       
  age INT CHECK (age >= 18),        
  course_id INT,                    
  grade CHAR(1) DEFAULT 'F'          
);

-- create another table courses and set up a foreign key constraint in the students table.The foreign key constraint ensures that the course_id in students must refer to a valid course_id in the courses table.
CREATE TABLE courses (
  course_id INT PRIMARY KEY,          
  course_name VARCHAR(100) NOT NULL   
);

-- Alter the students table to add the foreign key constraint
ALTER TABLE students
ADD CONSTRAINT forignkey_course
FOREIGN KEY (course_id)
REFERENCES courses (course_id)
ON DELETE CASCADE; 

--  insert some data into the students table while respecting the constraints.

INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (1, 'Rahul', 'rahul@example.com', 10, 101, 'C');  

INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (1, 'Babbulal', 'bob@example.com', 29, 102, 'B');  

INSERT INTO students (student_id, email, age, course_id, grade)
VALUES (3, 'charlie@example.com', 19, 103, 'B'); 

INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (4, 'Davdi', 'david@example.com', 16, 104, 'C');  

--  create a SELECT query that retrieves products based on numeric and date conditions. Retrieve products with a price greater than 100 and released after January 1, 2022
SELECT * 
FROM products 
WHERE price > 100 AND release_date > '2022-01-01';

--   update a record and set the last_updated column to the current datetime Update product details and set the last_updated to the current timestamp
UPDATE products
SET price = 1200.00, last_updated = NOW()  
WHERE product_id = 1;

-- delete products with stock below a certain threshold Delete products with stock below 70
DELETE FROM products 
WHERE stock < 70;
