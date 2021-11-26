use databasics;

insert into Employees(
    `Name`
    ,username
    ,`password`
    ,Salary
    ,Birthday
    ,Contact
    ,User_Rights
) values (
	"Timofey Hartanovich"
    , "admin"
    , "root"
    , 6000000.00
    , "2001-04-09"
    , "No Contact"
    , 1
);

insert into Customers(
    `Name`
    ,username
    ,`password`
    ,Address
    ,Contact
    ,User_Rights
) values (
	"Buyer"
    ,"Buyer"
    ,"1234"
    , "5800 buysome street"
    , "No Contact"
    , 2
);
