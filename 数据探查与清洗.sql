-- 1.数据探查与分析
-- 1.1 探查整体行数、各字段缺失值情况，以及连续变量的极值分布
SELECT
COUNT(*) AS total_cnt,
SUM(CASE WHEN label IS NULL THEN 1 ELSE 0 END) AS label_null_cnt,
SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_null_cnt,
SUM(CASE WHEN income IS NULL THEN 1 ELSE 0 END) AS income_null_cnt,
SUM(CASE WHEN profession IS NULL THEN 1 ELSE 0 END) AS profession_null_cnt,
MIN(age) AS min_age,
MAX(age) AS max_age,
MIN(income) AS min_income,
MAX(income) AS max_income,
MIN(experience_years) AS min_exp,
MAX(experience_years) AS max_exp,
MIN(current_job_years) AS min_job,
MAX(current_job_years) AS max_job
FROM train;

-- 1.2 探查label的分布情况
SELECT 
label, 
COUNT(*) AS label_cnt 
FROM train 
GROUP BY label;

-- 1.3探查profession的分布情况
SELECT 
rofession, 
COUNT(*) AS profession_cnt 
FROM train 
GROUP BY profession;
