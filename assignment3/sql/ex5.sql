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

-- Get vendor information that sells the most expensive item (used subquery)
select * from Vendors
where Vendors.ID = (select Vendor from Vendor_Items v where v.cost = (select max(cost) from vendor_items));

-- Get a list of vendors with a product price less than 50 cents (used exists)
select `Name` from Vendors v
where exists (select Item from Vendor_Items vi inner join Materials m on m.ID = vi.Item where vi.Vendor = v.ID and m.RM_Group like "14K Rose Gold");

-- Setup to demonstrate
/************************************************************************************************************
SET @VENDORID=null,@EMPLOYEEID=1,@MATERIAL=1840,@QTY=50;
insert into supply_orders (
	Material
	, Qty
	, Vendor
	, Ordered_By
	, Order_Date
) select
ID
, @QTY
, @VENDORID
, @EMPLOYEEID
, curdate()
from Materials where ID = @MATERIAL;  
SET @ORDID=1, @EMPLOYEEID=1;
update supply_orders set `Status`='OPEN', Approved_By = @EMPLOYEEID where ID=@ORDID and `Status`='NEW';
update materials set stock = 20 where ID > 20;
-- ********************************************************************************************************/
-- Return all supply_orders that arent complete or in production that do not have enough inventory to complete
select * from materials m
where exists(select * from supply_orders s
		join Bill_Of_Materials b on s.Material = b.Finished_Good
		inner join Materials m2 on b.Child = m2.ID
		where m2.Stock < b.Qty * s.Qty and s.Material = m.ID and s.Status <> "COMPLETE" and s.Status <> "PRODUCTION"); 

-- Return the total amount of raw materials that would cover all current demand orders
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
select m2.Item_Description Raw_Material, Sum(r.Qty*d.Qty) Qty_Ordered, MAX(m2.UOM) UOM from demand_orders d 
inner join materials m on m.ID = d.Material 
left join receipt r on r.FG = m.ID 
inner join materials m2 on r.Child = m2.ID 
where m2.Group_ID = "RM"
group by m2.Item_Description;