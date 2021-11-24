-- create demand-order
use databasics;
SET @CUSTOMERID=1, @EMPLOYEEID=null,@MATERIAL=1819,@QTY=50;

insert into demand_orders (
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
    
SET @CUSTOMERID=null, @EMPLOYEEID=1,@MATERIAL=1840,@QTY=25;
insert into demand_orders (
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
    
select * from demand_orders;
