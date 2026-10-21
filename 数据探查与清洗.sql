select 
count(*) as total_cnt,
sum(case when label is null then 1 else 0 end) as label_null_cnt,
sum(case when age is null then 1 else 0 end) as age_null_cnt,
sum(case when income is null then 1 else 0 end) as income_null_cnt,
sum(case when profession is null then 1 else 0 end) as profession_null_cnt,
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
