-- create supply-order
use databasics;
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

insert into Employees(
    `Name`
    ,Salary
    ,Birthday
    ,Contact
    ,User_Rights
) values (
	"Timofey Hartanovich"
    , 6000000.00
    , "2001-04-09"
    , "No Contact"
    , 1
);
select * from Employees