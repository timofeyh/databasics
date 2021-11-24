-- create inventory order by approving order
use databasics;

SET @ORDERID='@{ORDERID}', @EMPLOYEE='${EMPLOYEEID}';

insert into inv_orderers (orderer) select null from Orders where isNull(Inv_Orderer_ID) and ID = @ORDERID;

update Orders Set
Approved = @EMPLOYEE,
`Status` = 'OPEN',
Inv_Orderer_ID = last_insert_id()
Where ID = @ORDERID and isNull(Inv_Orderer_ID);

-- insert should only happen once when the status is changed to open
insert into inventory_orders (Ordered_By, Material, Qty, Order_Date, Opeartion) 
select 
Inv_Orderer_ID
, Material
, Qty
, CURDATE()
, 'DB'
from orders o
Where `Status` = 'OPEN' and ID=@ORDERERID;

