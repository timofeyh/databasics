use databasics;

drop view if exists lowsalary;
drop view if exists highsalary;
drop view if exists adminemployees;


CREATE VIEW LowSalary AS SELECT *
FROM Employees
WHERE Salary < 9000;

CREATE VIEW HighSalary AS SELECT *
FROM Employees
WHERE Salary > 10000
WITH LOCAL CHECK OPTION;

Create view On_Hand_Rings as select Item_Description Finished_Good, Sum(Stock*Price) Total_dollars, Sum(Stock) Total, UOM
from materials
where Group_ID = "FG" and Category = "Ring"
group by Item_Description;

update on_hand_rings set Finished_Good = "hello"; -- doesnt work
select * from on_hand_rings;
