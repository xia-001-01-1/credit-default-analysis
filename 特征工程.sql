alter table train add column income_level varchar(20);
update train 
set income_level=case
when income<2000000 then '<200w'
when income between 2000000 and 4000000 then '200w-400w'
when income between 4000001 and 6000000 then '400w-600w'
when income between 6000001 and 8000000 then '600w-800w'
when income>8000000 then '>800w'
end;

alter table train add column age_group varchar(20);
update train
set age_group=CASE
when age<30 then '<30'
when age between 30 and 39 then '30-39'
when age between 40 and 49 then '40-49'
when age between 50 and 59 then '50-59'
else '>60'
end;

SELECT DISTINCT house_ownership, car_ownership FROM train LIMIT 20;

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
