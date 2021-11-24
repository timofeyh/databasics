-- Create admin and customer user-rights
use databasics;

insert into user_rights(
	`description`
	,create_demand
    ,view_history
    ,approve_demand
    ,approve_supply
    ,create_supply
    ,view_inventory
    ,create_material
    ,view_bom
    ,create_employee
    ,stage_demand
    ,complete_demand
    ,produce_supply
    ,complete_supply)
values (
	"Admin"
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
), (
	"Customer"
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
    ,default
);
select * from user_rights;