use databasics;

-- Output the breakdown of any material
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

-- Return all orders that are in production and the materials that are being used
select s.ID `Order`, m2.ID `Material`, m2.Item_Description `Produced Item`, m.ID ID, m.Item_Description `Consumed Item`, b.Qty*s.Qty Required, m.UOM 
from supply_orders s 
left join bill_of_materials b on s.Material = b.Finished_Good 
inner join Materials m on b.Child = m.ID 
inner join Materials m2 on b.Finished_Good = m2.ID 
where s.`Status` = "PRODUCTION";

-- Return all customers with an order between 5000 and 20000 dollars
Select * from customers c
Inner join Demand_orders d on d.Customer = c.ID
Where d.Price between 5000 and 20000;

