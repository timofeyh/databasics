use databasics;
insert into user_rights(`description`,create_demand,view_history,approve_demand,approve_supply,create_supply,create_material,view_bom,create_employee,complete_demand,produce_supply,complete_supply)
values ("Admin",1,1,1,1,1,1,1,1,1,1,1), 
	   ("Customer",default,default,default,default,default,default,default,default,default,default,default);
select * from user_rights;

insert into Employees(`Name`,username,`password`,Salary,Birthday,Contact,User_Rights
) values ("Timofey Hartanovich", "admin", "root", 6000000.00, "2001-04-09", "No Contact", 1
);
select * from Employees;

insert into Customers(`Name`,username,`password`,Address,contact,User_Rights
) values ("Buyer","Buyer","1234", "5800 buysome street", "No Contact", 2
);
select * from Customers;

SET @VENDORID=null,@EMPLOYEEID=1,@MATERIAL=1840,@QTY=50;
insert into Supply_Orders (
	Material
	, Qty
	, Vendor
	, Ordered_By
	, Order_Date
) select
ID
, @QTY
, @VENDORID
, @EMPLOYEEID
, curdate()
from Materials where ID = @MATERIAL;   

select * from Supply_Orders;

-- create demand-order
use databasics;
SET @CUSTOMERID=1, @EMPLOYEEID=null,@MATERIAL=1819,@QTY=50;

insert into Demand_Orders (
	Material
	, Qty
	, Price
	, Customer
	, Order_Date
	, Ordered_By
) select
ID
, @QTY
, Price * @QTY
, @CUSTOMERID
, curdate()
, @EMPLOYEEID
from Materials where ID = @MATERIAL;
    
select * from Demand_Orders;
