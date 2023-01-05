Create Database EasyEl2;

Use EasyEl2;



Create Table Customer(
Customer_id Numeric(20) Primary Key,
Customer_name Varchar(20) NOT NULL,
Customer_address Varchar(30) NOT NULL,
Customer_contact Numeric(10) NOT NULL UNIQUE,
Customer_Email Varchar(20) NOT NULL UNIQUE
);

Create Table Orders(
Order_id Numeric(20) Primary Key,
Order_amount Numeric(20),
Order_date date NOT NULL,
Customer_id Numeric(20) NOT NULL UNIQUE,
FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);

Create Table Tracking(
Tracking_id Numeric(20) Primary Key,
Courier_name Varchar(20) NOT NULL,
Order_id Numeric(20) NOT NULL UNIQUE,
FOREIGN KEY (Order_id) REFERENCES Orders(Order_id)
);

Create Table Category(
Category_id Numeric(20) Primary Key,
Category_name Varchar(20) NOT NULL UNIQUE
);

Create Table Supplier(
Supplier_id Numeric(20) Primary Key,
Supplier_name Varchar(20) NOT NULL,
Supplier_contact Numeric(20) NOT NULL UNIQUE
);


Create Table Product(
Product_id Numeric(20) Primary Key,
Product_price Varchar(20) NOT NULL,
Category_id Numeric(20),
FOREIGN KEY (Category_id) REFERENCES Category(Category_id)
);

Create Table OrderDetails(
Order_id Numeric(20),
Product_id Numeric(20),
FOREIGN KEY (Order_id) REFERENCES Orders(Order_id),
FOREIGN KEY (Product_id) REFERENCES Product(Product_id)
);

Create Table SupplyProduct(
Supplier_id Numeric(20),
Product_id Numeric(20),
FOREIGN KEY (Supplier_id) REFERENCES Supplier(Supplier_id),
FOREIGN KEY (Product_id) REFERENCES Product(Product_id)
)



Select * from Customer;
Select * from Orders;
Select * from Tracking;
Select * from Category;
Select * from Supplier;
Select * from Product;
Select * from OrderDetails;
Select * from SupplyProduct;





#Total Products in each category

select c.Category_name, c.Category_id, count(p.Product_id) AS Total_Products
from Category c, Product p, OrderDetails od
where p.Category_id = c.Category_id and od.Product_id = p.Product_id
group by p.Category_id
order by Total_Products Desc;



#Products not present in an order

select p.Product_id 
from Product p
where not exists
(select od.Product_id
from OrderDetails od
where p.Product_id = od.Product_id);



#CUSTOMERS WHO HAVE ATLEAST ONE ORDER:

select c.Customer_id, c.Customer_name 
from Customer c
where exists
( select o.Order_id 
from Orders o
where c.Customer_id = o.Customer_id );


#FREQUENTLY USED COURIERS:
select Courier_name, count(*) AS frequency
from Tracking 
group by Courier_name;


#customers who either ordered product 51 or are named 'Ella'

select c.customer_id, c.customer_name from customer c where c.customer_name = 'Ella'
UNION
select c.customer_id, c.customer_name from customer c, orders o,orderdetails od where c.customer_id = o.customer_id and o.order_id = od.order_id
and od.product_id = 51;


#products not ordered by anyone

select p.product_id from product p, orderdetails od
where not p.product_id = od.product_id;


# Supplier of Costliest Product category

select s.supplier_id from supplier s, supplyproduct sp, product p2
where s.supplier_id = sp.supplier_id  and sp.product_id = p2.product_id and p2.category_id =
(select p.category_id from product p 
group by p.category_id 
having sum(p.product_price) >= all 
(select sum(p1.product_price) from product p1 group by p1.category_id));



# Customer name wwho has most recent order

select c.customer_name from customer c
where c.customer_id in 
(select c1.customer_id from customer c1, orders o
where c1.customer_id = o.customer_id and o.order_date >= all (
select order_date from orders));