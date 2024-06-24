use fun;
DELIMITER //
CREATE TRIGGER products_after_insert
AFTER INSERT ON product
FOR EACH ROW
BEGIN
  INSERT INTO product_log (pid, pname, price, stock, location, inserted_at)
  VALUES (NEW.pid, NEW.pname, NEW.price, NEW.stock, NEW.location, NOW());
END //
DELIMITER ;


-- create an SQL trigger to automatically update product stock levels after each new order is inserted into the 'orders' table?

delimiter // 
create trigger order_after_insert
after insert on orders
for each row
begin
	update product
    set stock = stock -1
    where pid = new.pid;
end //
delimiter ;

-- after update 

-- SQL trigger to log changes made to product information whenever an update occurs in the 'products' table?

delimiter //
create trigger product_after_update
after update on product
for each row
begin
	IF OLD.pid <> NEW.pid OR OLD.pname <> NEW.pname OR OLD.price <> NEW.price OR OLD.stock <> NEW.stock OR OLD.location <> NEW.location THEN
		insert into product_log(pid, pname,  price, stock, location, updated_at)
        values (OLD.pid, OLD.pname, OLD.price, OLD.stock, OLD.location, NOW());
	end if ;
end//
delimiter ;

-- after delete

-- SQL trigger to prevent the deletion of a product from the 'products' table if there are existing orders referencing that product in the 'orders' table?
delimiter //
create trigger product_after_delete
After delete on product
for each row
begin
	DECLARE has_orders INT DEFAULT (0);	
    SELECT COUNT(*) INTO has_orders
	FROM orders
	WHERE pid = OLD.pid;
    
    if has_order > 0 then
		signal SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete product with existing orders. Update or delete orders first.';
  END IF;
END //
DELIMITER ;


-- before insert

#Trigger for Automatic Payment Status on Payment Insert
DELIMITER //

CREATE TRIGGER set_default_payment_status
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
  IF NEW.status IS NULL THEN
    SET NEW.status = 'Pending';
  END IF;
END //

DELIMITER ;
-- Advanced triggers can be used to implement row-level security restrictions. For example, a trigger can filter data displayed to a user based on their role:
DELIMITER //
CREATE TRIGGER filter_products_by_role
BEFORE delete ON products
FOR EACH ROW
BEGIN
  DECLARE user_role VARCHAR(50);

  -- Get user role from session variable or another source
  SET user_role = 'user';  -- Replace with logic to get actual role

  IF user_role = 'admin' THEN
    SET FOUND = 1;  -- Allow admin to see all products
  ELSEIF user_role = 'user' AND NEW.location = 'Mumbai' THEN
    SET FOUND = 1;  -- Allow users to see only Mumbai products
  ELSE
    SET FOUND = 0;  -- Block other roles from seeing data
  END IF;
END //
DELIMITER ;



#Create a new view: If the view doesn't already exist, it defines a new virtual table based on a specified query.
#Replace an existing view: If a view with the same name already exists, it replaces its definition with the new query provided in the statement.


-- 1.example creates or replaces a view named active_customers_mumbai that shows customer ID, name, and address for customers older than 25 who live in addresses containing "Mumbai"

create or replace view active_customers_mumbai as
select cid, c.cname, c.addr
from customer c
WHERE c.age > 25 AND c.addr LIKE '%Mumbai%';

-- 2. View for Customers and their Orders

create view CustomerOrders as
select c.cid, c.cname, o.oid, o.amt, p.pname
from customer c
join orders o on c.cid = o.cid
join product p on o.pid = p.pid;

-- 3.View for Total Orders by Location

create view TotalOrdersByLocation as
select p.location, p.pname, count(o.oid) as total_orders
from product p
join orders o on p.pid = o.pid
group by p.location, p.pname;

-- 4.View for Payment Status

create view OrderPaymentStatus as
select o.oid, o.amt, p.mode, p.status
from orders o
join payment p on o.oid = p.oid;

-- removes a view from the database.
DROP VIEW active_customers_mumbai;


-- 2.Drop TotalOrdersByLocation View
drop view TotalOrdersByLocation;

# ------------------------------------------------Questions--------------------------------------------- 

-- Tcl commands
-- 1)Saving the command permently after running succesfully 
start transaction;
INSERT INTO products (pid, pname, price, stock, location) VALUES (8, 'iPhone 12', 79900, 10, 'Delhi');
INSERT INTO customer (cid, cname, age, addr) VALUES (106, 'John Doe', 35, '123 Main Street');
INSERT INTO orders (oid, cid, pid, amt) VALUES (1005, 106, 8, 79900);
INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES (1, 1005, 79900, 'credit', 'completed');
commit;

-- 2)Going to previous command 
start transaction;
INSERT INTO products (pid, pname, price, stock, location) VALUES (8, 'iPhone 12', 79900, 10, 'Delhi');
INSERT INTO customer (cid, cname, age, addr) VALUES (106, 'John Doe', 35, '123 Main Street');
INSERT INTO orders (oid, cid, pid, amt) VALUES (1005, 106, 8, 79900);
INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES (1, 1005, 79900, 'credit', 'completed');
rollback;
-- 3)Going to a check point where you want to go after saving the checkpoint 
start transaction;
INSERT INTO products (pid, pname, price, stock, location) VALUES (8, 'iPhone 12', 79900, 10, 'Delhi');
INSERT INTO customer (cid, cname, age, addr) VALUES (106, 'John Doe', 35, '123 Main Street');
INSERT INTO orders (oid, cid, pid, amt) VALUES (1005, 106, 8, 79900);
INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES (1, 1005, 79900, 'credit', 'completed');
SAVEPOINT A;
rollback TO A;


-- Triggers 
-- 1) Trigger to update status in payment table after an order is completed:
DELIMITER //
CREATE TRIGGER update_payment_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'completed' THEN
        UPDATE payment
        SET status = 'completed'
        WHERE oid = NEW.oid;
    END IF;
END //
DELIMITER ;
-- 2)Trigger to check stock availability before inserting an order:
DELIMITER //
CREATE TRIGGER check_stock_before_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    SELECT stock INTO available_stock FROM products WHERE pid = NEW.pid;
    IF available_stock < NEW.amt THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this product';
    END IF;
END //
DELIMITER ;
-- 3)Trigger to update stock after an order is placed:
DELIMITER //
CREATE TRIGGER update_stock_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.amt
    WHERE pid = NEW.pid;
END // 
DELIMITER ;
-- Veiws
-- 1)Create a view that displays the customers with their corresponding orders.
create view CustomerOrders as
select c.cid, c.cname, o.oid, o.amt, p.pname
from customer c
join orders o on c.cid = o.cid
join products p on o.pid = p.pid;

-- 2)Create or Replace View to show payment details with order and customer information
CREATE OR REPLACE VIEW payment_order_customer_details AS
SELECT p.pay_id, p.oid, o.cid, c.cname, c.age, c.addr, p.amount, p.mode, p.status
FROM payment p
JOIN orders o ON p.oid = o.oid
JOIN customer c ON o.cid = c.cid;

-- 3)Drop View if it exists
DROP VIEW IF EXISTS payment_order_customer_details;






