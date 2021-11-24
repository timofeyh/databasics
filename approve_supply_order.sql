-- approve supply_order
-- when employee logs in the backend will store the users clearance so this will only be accessible to those with approve supply rights
use databasics;

SET @ORDID=1, @EMPLOYEEID=1;
update supply_orders set `Status`='OPEN', Approved_By = @EMPLOYEEID where ID=@ORDID and `Status`='NEW';

select * from supply_orders;