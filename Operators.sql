create database operators;

-- A) ARITHMETIC OPERATORS:
SELECT 5+9;
-- b) Subtraction{-}:
SELECT 5-4;
-- c) Multiplication{+}:
SELECT 5*9;
-- d) Division{/}:
SELECT 5/2;
-- e) Modulo{%}:
SELECT 5%2;
-- B) COMPARISON OPERATORS
SELECT 5=5;

-- b) Greater Than{>}: Gives true if left operand is greater. Ex- 5>3
-- USAGE
SELECT 5>3;

-- c) Less Than{<}: Gives true if left operand is lesser. Ex- 3<5
-- USAGE
SELECT 3<5;

-- d) Greater Than or Equals To{>=}: Gives true if left operand is greater or equal. Ex- 5>=5
-- USAGE
SELECT 5>=5;

-- e) Less Than or Equals To{<=}: Gives true if left operand is lesser or equal. Ex- 5<=6
-- USAGE
SELECT 5<=6;

-- e)Not Eqauls To{<> or !=}: Gives true if operands are unequal. Ex- 5<=6
-- USAGE
SELECT 5<>6;

-- C) BITWISE OPERATORS
--    They compare each bit of the first operand to the correponding bit of the second operand and produce a final result.
--    Basically, Operands are converted to binary and than operated on by operators and the binary result is converted to human readable form.
-- They are of 3 types:
-- a) Bitwise AND{&}: Result contains AND operated bits. Ex- 59&47=43
-- USAGE
SELECT 59 & 47;

-- b) Bitwise OR{|}: Result contains OR operated bits. Ex- 59|47=63
-- USAGE
SELECT 59 | 47;

-- c) Bitwise XOR{^}: Result contains XOR operated bits. Ex- 59^47=20
-- USAGE
SELECT 59 ^ 47;

-- D) LOGICAL OPERATORS
--    They connect two or more boolean expressions such that the result of the compound expression depends on the
--    results of the original expressions and on the meaning of the operator. Results are in True and False.
-- Commonly Used Types:
-- a) AND: Gives True if all conditions separated by AND are True. Ex- 4!=6 AND 12>6
-- USAGE
SELECT 4!=6 AND 12>6;

-- b) OR: Gives True if any of the conditions separated by OR is True. Ex- 5>4 AND 10=6
-- USAGE
SELECT 5>4 AND 10=6;

-- c) NOT: Gives true if condition is False, false if condition is True. Ex- NOT 3<5
-- USAGE
SELECT NOT 3<5;

-- d) LIKE: Gives true if operand matches a pattern. Ex- 'Hello' LIKE '%o'
-- USAGE
SELECT 'Hello' LIKE '%o';

-- e) BETWEEN: Gives true if operand is within the range of comparisons. Ex- 5 BETWEEN 1 AND 10
-- USAGE
SELECT 5 BETWEEN 1 AND 10;

# --------------------------------------------QUESTIONS---------------------------------------------

-- Arithmetic Operators:
-- 1) Write a query to calculate the total revenue by adding the prices of all products in the products table.
SELECT SUM(price) AS total_revenue 
FROM products;
-- 2) Write a query to find the products whose price is divisible by 3 using the modulo operator (%).
SELECT * 
FROM products 
WHERE price % 3 = 0;
-- 3) Write a query to subtract the average price from the price of each product and display the result as 
SELECT pid, pname, price, 
(price - (SELECT AVG(price) FROM products)) AS price_difference 
FROM products;
   
-- Comparison Operators:
-- 1) Write a query to retrieve all products whose price is greater than or equal to 50000.
SELECT * 
FROM products 
WHERE price >= 50000;
-- 2) Write a query to find the customers whose age is not equal to 30.
SELECT * 
FROM customer 
WHERE age != 30;
-- 3) Write a query to retrieve all orders where the order amount is less than or equal to 10000.
SELECT * 
FROM orders 
WHERE amt <= 10000;

-- Bitwise Operators:
-- 1) Explain the bitwise AND (&) operator with an example.
SELECT id, num1, num2, (num1 & num2) AS result
FROM numbers;
-- 2) Explain the bitwise OR (|) operator with an example.
SELECT id, num1, num2, (num1 | num2) AS result
FROM numbers;
-- 3) Explain the bitwise XOR (^) operator with an example.
SELECT id, num1, num2, (num1 ^ num2) AS result
FROM numbers;

-- Logical Operators:
-- 1) Write a query to retrieve the products that are located in Mumbai and have a stock level greater than 10.
SELECT * 
FROM products 
WHERE location = 'Mumbai' 
AND stock > 10;
-- 2) Write a query to find the customers who are either from Mumbai or have placed an order with an amount greater
than 20000.
SELECT * 
FROM customer 
WHERE addr LIKE '%Mumbai%' 
OR
(SELECT SUM(amt) 
FROM orders o 
WHERE o.cid = customer.cid) > 20000;
-- 3) Write a query to retrieve the orders where the payment mode is not 'upi' and the status is 'completed'.
SELECT * 
FROM payment 
WHERE mode != 'upi' 
AND status = 'completed';

# ANSWERS
-- Arithmetic Operators:

-- 2)

-- 3)


-- Comparison Operators:
-- 1)

-- 2)

-- 3) 


-- Logical Operators:
-- 1)
SELECT * 
FROM products 
WHERE location = 'Mumbai' 
AND stock > 10;
-- 2)
 

-- 3)
