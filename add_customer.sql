-- Adding a Customer
use databasics;

insert into Orderers (ID) values (null);
-- Get the last insert id

insert into Customers (Orderer_ID, Customer_Name, Address) values (/*Returned ID*/0, "NAME", 0.00, "200 Highhill Lane")
