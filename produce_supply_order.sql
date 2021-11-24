-- produce supply order
-- available to produce_supply
use databasics;

SET @ORDID=1;
Start transaction;
	SET @COMPLETE = not exists(select * from supply_orders s2
		join Bill_Of_Materials b on s2.Material = b.Finished_Good
		inner join Materials m2 on b.Child = m2.ID
		where m2.Stock < b.Qty * s2.Qty and s2.ID = @ORDID); 
	SET @READY = EXISTS(Select `Status` from supply_orders where ID=@ORDID and `Status` = 'OPEN');
	update supply_orders s 
    inner join materials m on s.Material = m.ID 
    set s.`Status`='PRODUCTION' 
    ,s.Start_Date = curdate()
    where s.ID=@ORDID 
    and s.`Status` = 'OPEN'
    and @COMPLETE;
    
	update materials m 
	inner join supply_orders s on s.Material = m.ID
	set 
	m.WIP = m.WIP + s.Qty
	where s.ID = @ORDID and @COMPLETE and @READY;
    
    update materials m 
    inner join supply_orders s on s.Material = m.ID
    join bill_of_materials b on b.Finished_Good = m.ID
    inner join materials c on b.Child = c.ID
    set c.Stock = c.Stock - s.Qty * b.Qty
    where @COMPLETE and s.ID = @ORDID and @READY;
commit;
select * from supply_orders;
    
select m.* from materials m inner join supply_orders d on m.ID = d.Material where d.ID = @ORDID;

select c.* from materials m 
    inner join supply_orders s on s.Material = m.ID
    join bill_of_materials b on b.Finished_Good = m.ID
    inner join materials c on b.Child = c.ID
    where @COMPLETE and s.ID = @ORDID;