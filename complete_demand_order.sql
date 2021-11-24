-- complete demand_order
-- available to complete_demand

use databasics;

SET @ORDID=1;
Start transaction;
	SET @READY = EXISTS(Select `Status` from demand_orders where ID=@ORDID and `Status` = 'STAGED');
	update demand_orders d inner join materials m on d.Material = m.ID set d.`Status`='COMPLETE', d.Completion_Date = curdate() where d.ID=@ORDID and d.`Status` = 'STAGED';
	update materials m 
	inner join demand_orders d on d.Material = m.ID
	set 
	m.Staged = m.Staged - d.Qty
	where d.ID = @ORDID and @READY;
commit;
select * from demand_orders;
select * from materials m inner join demand_orders d on m.ID = d.Material where d.ID = @ORDID;