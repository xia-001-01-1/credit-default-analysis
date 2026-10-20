alter table train add column asset_status varchar(20);
update train
set asset_status=
CASE
WHEN house_ownership='owned' and car_ownership='yes'then'1-有车有房'
WHEN house_ownership = 'owned' AND car_ownership = 'no' THEN '2-仅有房'
WHEN house_ownership != 'owned' AND car_ownership = 'yes' THEN '3-仅有车'
ELSE '4-无房无车'
END;

ALTER TABLE train ADD COLUMN house_status VARCHAR(20);
UPDATE train 
SET house_status = CASE 
WHEN house_ownership = 'owned' THEN '1-有房'
WHEN house_ownership = 'rented' THEN '2-租房'
ELSE '3-无房无租'
END;

SELECT 
id, 
age, age_group, 
income, income_level, 
house_ownership, car_ownership, asset_status, 
label 
FROM train 
LIMIT 10;
