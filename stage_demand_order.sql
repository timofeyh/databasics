-- stage demand_order
-- only accessible when employee has stage_demand rights
use databasics;

SET @ORDID=1;
Start transaction;
	SET @READY = EXISTS(Select `Status` from demand_orders where ID=@ORDID and `Status` = 'OPEN');
	update demand_orders d inner join materials m on d.Material = m.ID set d.`Status`='STAGED' where d.ID=@ORDID and m.Stock > d.Qty and d.`Status` = 'OPEN';
	update materials m 
	inner join demand_orders d on d.Material = m.ID
	set 
	m.Stock = m.Stock - d.Qty
	, m.Staged = m.Staged + d.Qty
	where d.ID = @ORDID and m.Stock > d.Qty and @READY;
commit;
select * from demand_orders;
select * from materials m inner join demand_orders d on m.ID = d.Material where d.ID = @ORDID;