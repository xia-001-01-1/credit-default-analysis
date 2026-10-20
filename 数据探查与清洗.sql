select 
count(*),
sum(case when label is null then 1 else 0 end) as label_cnt,
sum(case when age is null then 1 else 0 end) as age_cnt,
sum(case when income is null then 1 else 0 end) as income_cnt,
sum(case when profession is null then 1 else 0 end) as profession_cnt,
min(age),
max(age),
min(income),
max(income),
min(experience_years),
max(experience_years),
min(current_job_years), 
max(current_job_years)
from train;

alter table train modify column label int;

alter table train add column income_level varchar(20);
update train 
set income_level=case
when income<500000 then '<50w'
when income between 500000 and 1000000 then '50w-100w'
when income between 1000001 and 2000000 then '100w-200w'
when income between 2000001 and 5000000 then '200w-500w'
when income>5000000 then '>500w'
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
