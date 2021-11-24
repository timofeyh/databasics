use databasics;

SET @ORDERER='${Orderer}', @MATERIAL='${Material}', @QTY='${Qty}';

insert into Orders (Orderer, Material, Qty, Price, Order_Date) 
select 
@ORDERER
, ID -- Gonna be a FG material (A)
, @QTY -- Inputted Integer
, Price -- Taken from materials
, CURDATE()
from Materials
Where ID = @MATERIAL -- same as A
