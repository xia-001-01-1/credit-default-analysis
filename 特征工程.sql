ALTER TABLE train ADD COLUMN income_level VARCHAR(20);

UPDATE train 
SET income_level = CASE
WHEN income < 2000000 THEN '<200w'
WHEN income BETWEEN 2000000 AND 4000000 THEN '200w-400w'
WHEN income BETWEEN 4000001 AND 6000000 THEN '400w-600w'
WHEN income BETWEEN 6000001 AND 8000000 THEN '600w-800w'
WHEN income > 8000000 THEN '>800w'
END;


ALTER TABLE train ADD COLUMN age_group VARCHAR(20);

UPDATE train
SET age_group = CASE
WHEN age < 30 THEN '<30'
WHEN age BETWEEN 30 AND 39 THEN '30-39'
WHEN age BETWEEN 40 AND 49 THEN '40-49'
WHEN age BETWEEN 50 AND 59 THEN '50-59'
ELSE '>60'
END;

SELECT DISTINCT house_ownership, car_ownership FROM train LIMIT 20;

ALTER TABLE  train ADD COLUMN asset_status varchar(20);
UPDATE train
SET asset_status=
CASE
WHEN house_ownership='owned' AND car_ownership='yes' THEN '1-有车有房'
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
age, 
age_group, 
income, 
income_level, 
house_ownership, 
car_ownership, 
asset_status, 
label 
FROM train 
LIMIT 10;
