use databasics;
with recursive receipt(n, FG, FG_txt, Parent, Parent_txt, Child, Child_txt, Qty, UOM, Scrap, Price,`Group`) as 
(
	select 1 n, m.ID, m.Item_Description, m.ID, m.Item_Description, m2.ID Child, m2.Item_Description, CAST(1.00 as double) QTY, m2.UOM, 0.00 Scrap, m2.Price Price, m2.Group_ID From bill_of_materials b
    inner join Materials m on b.Finished_Good = m.ID
    inner join Materials m2 on b.Child = m2.ID
    Union All
    select 1 + n, r.FG, r.FG_Txt, m.ID, m.Item_Description, m2.ID, m2.Item_Description, b.Qty*r.Qty, m2.UOM, b.Scrap, m2.Price, m2.Group_ID From Bill_Of_Materials b
    inner join Materials m on b.Finished_Good = m.ID
    inner join Materials m2 on b.Child = m2.ID
    inner join receipt r on r.Child = m.ID
)
select * from receipt where FG = 9;