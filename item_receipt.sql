use databasics;
SET @QTY=CAST(50 as double);
with recursive receipt(n, ID, Item_Description, Qty, UOM, Scrap, Price) as 
(
	select 1 n, ID ID, Item_Description Item_Desc, @Qty QTY, UOM, 0.00 Scrap, @Qty*Price Price From Materials
    where ID = 1840
    Union All
    select 1+ n, b.Child ID, m.Item_Description Item_Desc, b.Qty*r.Qty Qty, m.UOM, b.Scrap, m.Price From Bill_Of_Materials b
    inner join Materials m on b.Child = m.ID
    inner join receipt r on r.ID = b.Finished_Good
)
select * from receipt;