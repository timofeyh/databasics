-- approve demand_order
-- when employee logs in the backend will store the users clearance so this will only be accessible to those with approve demand rights
use databasics;

SET @ORDID=1,@EMPLOYEEID=1;
update demand_orders set `Status`='OPEN', Approved_By=@EMPLOYEEID where ID=@ORDID and `Status`='NEW';

select * from demand_orders;