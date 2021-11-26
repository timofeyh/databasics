use databasics;

-- INSERT STATEMENTS FOR QUESTION 4 (ALSO HAVE INTERESTING WAYS OF INSERTING AND MUST BE RUN BEFORE THESE COMMANDS -- (Add a forward slash to unhide and populate materials and bill_of_materials \V/)
/*************************************************************************************************************************************************************************************************
drop table IF EXISTS wire_gauges;
create table wire_gauges (gauge varchar(255));

drop table IF EXISTS ring_sizes;
create table ring_sizes (size varchar(255));

drop table IF EXISTS chain_types;
create table chain_types (cType varchar(255));

drop table IF EXISTS chain_lengths;
create table chain_lengths (len double);

insert into Materials (Item_Description, Group_ID, Category, Sub_Category, Size, UOM, RM_Group) values 
("Sterling Silver", "RM", "Metal", "Silver", 1, "g", "Sterling Silver")
, ("Mexican Silver", "RM", "Metal", "Silver", 1, "g", "Mexican Silver")
, ("Silver", "RM", "Metal", "Silver", 1, "g", "Silver")
, ("Palladium", "RM", "Metal", "Palladium", 1, "g", "Palladium")
, ("Rhodium", "RM", "Metal", "Rhodium", 1, "g", "Rhodium")
, ("Platinum", "RM", "Metal", "Platinum", 1, "g", "Platinum")
, ("14K Rose Gold", "RM", "Metal", "Rose Gold", 1, "g", "14K Rose Gold")
, ("18K Rose Gold", "RM", "Metal", "Rose Gold", 1, "g", "18K Rose Gold")
, ("14K Nickel White Gold", "RM", "Metal", "White Gold", 1, "g", "14K Nickel White Gold")
, ("14K Palladium White Gold", "RM", "Metal", "White Gold", 1, "g", "14K Palladium White Gold")
, ("18K Palladium White Gold", "RM", "Metal", "White Gold", 1, "g", "18K Palladium White Gold")
, ("14K Yellow Gold", "RM", "Metal", "Yellow Gold", 1, "g", "14K Yellow Gold")
, ("18K Yellow Gold", "RM", "Metal", "Yellow Gold", 1, "g", "18K Yellow Gold")
, ("22K Yellow Gold", "RM", "Metal", "Yellow Gold", 1, "g", "22K Yellow Gold");

insert into wire_gauges (gauge) values 
("24 gauge")
, ("22 gauge")
, ("21 gauge")
, ("20 gauge")
, ("18 gauge")
, ("16 gauge")
, ("14 gauge")
, ("12 gauge")
, ("10 gauge");

insert into Materials (Item_Description, Group_ID, Category, Sub_Category, Size, UOM, RM_Group)
select concat(g.gauge, " ", m.Item_Description, " wire")
, "WIP"
, "Wire"
, g.gauge
, ROUND(CAST(LEFT(g.gauge, 2) as double),2)
, "m"
, m.RM_Group 
from Materials m
join wire_gauges g on 1
where m.Group_ID = "RM";

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap)
select 
m.ID
, c.ID
, ROUND(1000 / POWER(CAST(LEFT(m.Item_Description, 2) as double),2),2)
, 0
from Materials m
inner join Materials c on m.RM_Group = c.Item_Description
where m.Group_ID = "WIP"; 

insert into ring_sizes(size) values 
("3")
, ("3.5")
, ("4")
, ("4.5")
, ("5")
, ("5.5")
, ("6")
, ("6.5")
, ("7")
, ("7.5")
, ("8")
, ("8.5")
, ("9")
, ("9.5")
, ("10")
, ("10.5")
, ("11")
, ("11.5")
, ("12")
, ("12.5")
, ("13")
, ("13.5");

insert into Materials (Item_Description, Group_ID, Category, Sub_Category, Size, UOM, RM_Group, Price)
select concat("Ring ", LEFT(m.Item_Description,LENGTH(m.Item_Description)-5), " Size: ", r.size)
, "FG"
, "Ring"
, m.RM_Group
, CAST(r.size as double)
, "EA"
, m.RM_Group
, ROUND(CAST(if(LEFT(m.RM_Group, 2) REGEXP '[0-9]', LEFT(m.RM_Group, 2), 12.00) as double) / 24.00 * 500.00 * POWER(r.size / 15, 0.5) * POWER(10/LEFT(m.Item_Description, 2), 0.5), 2)
from Materials m
join ring_sizes r on LEFT(m.Item_Description, 2) < 15
where m.Group_ID = "WIP";

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap)
select 
m.ID
, c.ID
, ROUND(0.05 * CAST(RIGHT(RIGHT(m.Item_Description, 4), 4 - POSITION(" " IN RIGHT(m.Item_Description, 4))) as double),2)
, 0.3
from Materials m
inner join Materials c on m.RM_Group = c.RM_Group and RIGHT(LEFT(m.Item_Description, 7),2) = LEFT(c.Item_Description,2)
where m.Group_ID = "FG" and c.Group_ID = "WIP"; 

insert into chain_types(cType) values 
("Figaro")
, ("Box")
, ("Rope")
, ("Cuban Link")
, ("Herringbone");
-- , ("Double Rope")
-- , ("Cable")
-- , ("Snake");

insert into Materials (Item_Description, Group_ID, Category, Sub_Category, Size, UOM, RM_Group)
select concat(LEFT(m.Item_Description,LENGTH(m.Item_Description)-5), " ", c.cType, " Chain")
, "WIP"
, "RAW Chain"
, c.cType
, CAST(LEFT(m.Item_Description, 2) as double)
, "m"
, m.RM_Group 
from Materials m
join chain_types c on LEFT(m.Item_Description, 2) > 15
where m.Group_ID = "WIP" and RIGHT(m.Item_Description, 4) = "wire";

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap)
select 
m.ID
, c.ID
, ROUND(LENGTH(m.Item_Description) / 10, 2)
, 0.25
from Materials m
inner join Materials c on LEFT(m.Item_Description, LENGTH(c.Item_Description) - 5) = LEFT(c.Item_Description, LENGTH(c.Item_Description)-5)
where m.Group_ID = "WIP" and c.Group_ID = "WIP" and m.ID <> c.ID; 

insert into chain_lengths(len) values 
(16)
, (18)
, (20)
, (22)
, (24);

insert into Materials (Item_Description, Group_ID, Category, Sub_Category, Size, UOM, RM_Group, Price)
select concat(c.len, '" ', m.Item_Description)
, "FG"
, "Chain"
, m.Sub_Category
, c.len
, "EA"
, m.RM_Group 
, ROUND(CAST(if(LEFT(m.RM_Group, 2) REGEXP '[0-9]',LEFT(m.RM_Group, 2),12) as double) / 24.00 * c.len * 50 * POWER(10/LEFT(m.Item_Description,2), 0.5), 2)
from Materials m
join chain_lengths c on RIGHT(m.Item_Description, 5) = "Chain"
where m.Group_ID = "WIP";

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap)
select 
m.ID
, c.ID
, ROUND(3 * CAST(LEFT(m.Item_Description, 2) as double) / 100, 2)
, 0.2
from Materials m
inner join Materials c on RIGHT(m.Item_Description, LENGTH(m.Item_Description) - 4) = c.Item_Description and c.Group_ID = "WIP"
where m.Group_ID = "FG" and RIGHT(m.Item_Description, 5) = "Chain"; 

insert into Materials (Item_Description, Group_ID, Category, UOM, RM_Group)
select concat(m.Item_Description, " clasp")
, "WIP"
, "Clasp"
, "EA"
, m.RM_Group 
from Materials m
where m.Group_ID = "RM";

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap) 
select
m.ID
, c.ID
, 0.5
, 0.01
from Materials m 
inner join Materials c on c.Item_Description = m.RM_Group
where RIGHT(m.Item_Description, 5) = "clasp";

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap)
select
m.ID
, c.ID
, 1 
, 0
from Materials m
inner join Materials c on c.RM_Group = m.RM_Group and RIGHT(c.Item_Description, 5) = "clasp"
where m.Group_ID = "FG" and RIGHT(LEFT(m.Item_Description, 3), 1) = '"';

insert into Materials (Item_Description, Group_ID, Category, Sub_Category, Size, UOM) values ("Machining Oil", "RM", "Manufacturing", "Oil", 1, "L");

insert into Bill_Of_Materials (Finished_Good, Child, Qty, Scrap) 
select
m.ID
, c.ID
, 0.01
, 0
from Materials m 
join Materials c on c.Item_Description = "Machining Oil"
where RIGHT(m.Item_Description, 4) = "wire";

select * from Bill_Of_Materials;
select * from Materials;

drop table IF EXISTS wire_gauges;
drop table IF EXISTS ring_sizes;
drop table IF EXISTS chain_types;
drop table IF EXISTS chain_lengths;
-- *************************************************************************************************************************************************************************************************/

insert into user_rights(`description`,create_demand,view_history,approve_demand,approve_supply,create_supply,create_material,view_bom,create_employee,complete_demand,produce_supply,complete_supply)
values ("Admin",1,1,1,1,1,1,1,1,1,1,1), 
	   ("Customer",default,default,default,default,default,default,default,default,default,default,default);
select * from user_rights;

insert into Employees(`Name`,username,`password`,Salary,Birthday,Contact,User_Rights
) values ("Timofey Hartanovich", "admin", "root", 6000000.00, "2001-04-09", "No Contact", 1
);
select * from Employees;

insert into Customers(`Name`,username,`password`,Address,contact,User_Rights
) values ("Buyer","Buyer","1234", "5800 buysome street", "No Contact", 2
);
select * from Customers;

SET @VENDORID=null,@EMPLOYEEID=1,@MATERIAL=1840,@QTY=50;
insert into Supply_Orders (
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

select * from Supply_Orders;

-- create demand-order
use databasics;
SET @CUSTOMERID=1, @EMPLOYEEID=null,@MATERIAL=1819,@QTY=50;

insert into Demand_Orders (
	Material
	, Qty
	, Price
	, Customer
	, Order_Date
	, Ordered_By
) select
ID
, @QTY
, Price * @QTY
, @CUSTOMERID
, curdate()
, @EMPLOYEEID
from Materials where ID = @MATERIAL;
    
select * from Demand_Orders;
