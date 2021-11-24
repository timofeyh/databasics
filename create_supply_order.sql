-- create supply-order
use databasics;
SET @VENDORID=null,@EMPLOYEEID=1,@MATERIAL=1840,@QTY=50;
insert into supply_orders (
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

SET @VENDORID=null, @EMPLOYEEID=1,@MATERIAL=1819,@QTY=50;
insert into supply_orders (
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

select * from supply_orders;
