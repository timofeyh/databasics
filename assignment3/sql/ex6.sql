use databasics;

SET @ORDID=1,@EMPLOYEEID=1;
update demand_orders set `Status`='OPEN', Approved_By=@EMPLOYEEID where ID=@ORDID and `Status`='NEW';

select * from demand_orders;

SET @ORDID=1, @EMPLOYEEID=1;
update supply_orders set `Status`='OPEN', Approved_By = @EMPLOYEEID where ID=@ORDID and `Status`='NEW';

select * from supply_orders;

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