use databasics;
with recursive receipt(n, FG, ID, Item_Description, Qty, UOM, Scrap, Price) as 
(
	select 1 n, 0, ID ID, Item_Description Item_Desc, CAST(1.00 as double) QTY, UOM, 0.00 Scrap, Price Price From Materials
    Union All
    select 1 + n, b.Finished_Good, b.Child ID, m.Item_Description Item_Desc, b.Qty*r.Qty Qty, m.UOM, b.Scrap, m.Price From Bill_Of_Materials b
    inner join Materials m on b.Child = m.ID
    inner join receipt r on r.ID = b.Finished_Good
)
select r.ID ID, m.Item_Description Item_Description, r.Qty*s.Qty Required from supply_orders s left join receipt r on s.Material = r.FG inner join Materials m on r.ID = m.ID where s.`Status` = "PRODUCTION";