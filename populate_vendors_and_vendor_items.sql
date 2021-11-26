-- populate vendors and vendor_items
insert into Vendors(`Name`,address, contact) 
values ('Gold Sir+', '100 fools way','End of the rainbow')
	,('Argentum and finer things', 'Aristocrat boulevard','Google me');
    
insert into Vendor_Items(Vendor, Item, Cost) 
values (1, 4, 60)
		,(1, 7, 30)
		,(1, 8, 40)
        ,(1, 9, 30)
        ,(1, 10, 30)
        ,(1, 11, 40)
        ,(1, 12, 30)
        ,(1, 13, 40)
		,(1, 14, 50)
        ,(1, 1, 0.6)
        ,(2, 2, 0.5)
        ,(2, 3, 0.4)
        ,(2, 5, 340)
        ,(2, 6, 35)
        ,(2, 5786, 1)
        ,(2, 5787, 2)
        ,(2, 5788, 5);