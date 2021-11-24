-- complete supply_order
-- available to complete_supply

use databasics;

SET @ORDID=1;
Start transaction;
	SET @READY = EXISTS(Select `Status` from supply_orders where ID=@ORDID and `Status` = 'PRODUCTION');
	update supply_orders s inner join materials m on s.Material = m.ID set s.`Status`='COMPLETE', s.Completion_Date = curdate() where s.ID=@ORDID and s.`Status` = 'PRODUCTION';
	update materials m 
	inner join supply_orders s on s.Material = m.ID
	set 
	m.WIP = m.WIP - s.Qty
    , m.Stock = m.Stock + s.Qty
	where s.ID = @ORDID and @READY;
commit;
select * from supply_orders;
select * from materials m inner join supply_orders s on m.ID = s.Material where s.ID = @ORDID;