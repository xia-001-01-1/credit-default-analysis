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
