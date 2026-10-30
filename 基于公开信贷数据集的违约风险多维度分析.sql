-- 1. 数据探查与清洗
SELECT
	count(*) AS 总行数,
	count(DISTINCT id) AS 唯一id数,
	sum(label IS NULL) AS label缺失,
	sum(label NOT IN(0, 1)) AS label非01,
	sum(income IS NULL) AS income缺失,
	sum(age IS NULL) AS age缺失,
	sum(profession IS NULL) AS profession缺失,
	sum(house_ownership IS NULL) AS house缺失,
	sum(car_ownership IS NULL) AS car缺失,
	sum(experience_years > age - 16) AS 工龄大于16岁,
	sum(
		current_job_years > experience_years
	) AS 现职超总工龄,
	sum(income <= 0) AS 收入非正,
	min(age),
	max(age),
	min(income),
	max(income),
	min(experience_years),
	max(experience_years),
	min(current_job_years),
	max(current_job_years)
FROM
	train;

-- 2. 建立分箱规则配置表
CREATE TABLE bin_rule (
	dim VARCHAR (20) NOT NULL,
	lo DECIMAL (12, 0) NOT NULL,
	hi DECIMAL (12, 0) NOT NULL,
	bin_name VARCHAR (20) NOT NULL
) ENGINE = INNODB DEFAULT charset = utf8mb4;

INSERT INTO bin_rule (dim, lo, hi, bin_name)
VALUES
	(
		'income',
		0,
		2000000,
		'1-<200w'
	),
	(
		'income',
		2000000,
		4000000,
		'2-200w-400w'
	),
	(
		'income',
		4000000,
		6000000,
		'3-400w-600w'
	),
	(
		'income',
		6000000,
		8000000,
		'4-600w-800w'
	),
	(
		'income',
		8000000,
		999999999,
		'5->800w'
	),
	('age', 0, 30, '1-<30'),
	('age', 30, 40, '2-30-39'),
	('age', 40, 50, '3-40-49'),
	('age', 50, 60, '4-50-59'),
	('age', 60, 200, '5-60+');

-- 3. 建立特征表
DROP TABLE
IF EXISTS train_feat;

CREATE TABLE train_feat AS SELECT
	t.*, COALESCE (bi.bin_name, '9-未知') AS income_level,
	COALESCE (ba.bin_name, '9-未知') AS age_group,
	CASE
WHEN t.house_ownership = 'owned'
AND t.car_ownership = 'yes' THEN
	'1-有车有房'
WHEN t.house_ownership = 'owned'
AND t.car_ownership = 'no' THEN
	'2-仅有房'
WHEN t.house_ownership <> 'owned'
AND t.car_ownership = 'yes' THEN
	'3-仅有车'
WHEN t.house_ownership <> 'owned'
AND t.car_ownership = 'no' THEN
	'4-无房无车'
ELSE
	'9-未知'
END AS asset_status,
 CASE
WHEN t.house_ownership = 'owned' THEN
	'1-有房'
WHEN t.house_ownership = 'rented' THEN
	'2-租房'
WHEN t.house_ownership = 'norent_noown' THEN
	'3-无房无租'
ELSE
	'9-未知'
END AS house_status
FROM
	train t
LEFT JOIN bin_rule bi ON bi.dim = 'income'
AND t.income >= bi.lo
AND t.income < bi.hi
LEFT JOIN bin_rule ba ON ba.dim = 'age'
AND t.age >= ba.lo
AND t.age < ba.hi;

-- 4. 特征分箱风控分析
SELECT
	u.dim AS 维度,
	u.grp AS 分组,
	u.n AS 总人数,
	u.nl AS 有效样本,
	u.bad AS 违约数,
	round(100 * u.bad / u.nl, 2) AS 违约率,
	round((u.bad / u.nl) / b.base_rate, 2) AS lift
FROM
	(
		SELECT
			'收入' AS dim,
			income_level AS grp,
			count(*) AS n,
			count(label) AS nl,
			sum(label) AS bad
		FROM
			train_feat
		GROUP BY
			income_level
		UNION ALL
			SELECT
				'年龄',
				age_group,
				count(*),
				count(label),
				sum(label)
			FROM
				train_feat
			GROUP BY
				age_group
			UNION ALL
				SELECT
					'资产',
					asset_status,
					count(*),
					count(label),
					sum(label)
				FROM
					train_feat
				GROUP BY
					asset_status
				UNION ALL
					SELECT
						'房产',
						house_status,
						count(*),
						count(label),
						sum(label)
					FROM
						train_feat
					GROUP BY
						house_status
	) u
CROSS JOIN (
	SELECT
		avg(label) AS base_rate
	FROM
		train
) b
ORDER BY
	u.dim,
	u.grp;

-- 5.显著性检验
SELECT
	c.grp AS 资产组合,
	c.n AS 样本量,
	round(100 * c.rate, 2) AS 违约率,
	round(100 * c.lo, 2) AS ci下限,
	round(100 * c.hi, 2) AS ci上限,
	CASE
WHEN c.lo > (SELECT avg(label) FROM train) THEN
	'显著高于基准'
WHEN c.hi < (SELECT avg(label) FROM train) THEN
	'显著低于基准'
ELSE
	'与基准无差异'
END AS 判定
FROM
	(
		SELECT
			d.grp,
			d.n,
			d.rate,
			d.rate - 1.96 * sqrt(d.rate *(1 - d.rate) / d.n) AS lo,
			d.rate + 1.96 * sqrt(d.rate *(1 - d.rate) / d.n) AS hi
		FROM
			(
				SELECT
					asset_status AS grp,
					count(*) AS n,
					sum(label) / count(label) AS rate
				FROM
					train_feat
				GROUP BY
					asset_status
			) d
	) c
ORDER BY
	c.rate;

-- 6. 交叉分析
-- 6.1 年龄段 × 资产组合
SELECT
	COALESCE (t.ag, '合计') AS 年龄段,
	COALESCE (t.as_, '小计') AS 资产组合,
	t.n AS 样本量,
	t.bad AS 违约数,
	round(100 * t.bad / t.nl, 2) AS 违约率,
	round((t.bad / t.nl) / b.base_rate, 2) AS lift
FROM
	(
		SELECT
			age_group AS ag,
			asset_status AS as_,
			count(*) AS n,
			count(label) AS nl,
			sum(label) AS bad
		FROM
			train_feat
		GROUP BY
			age_group,
			asset_status WITH ROLLUP
	) t
CROSS JOIN (
	SELECT
		avg(label) AS base_rate
	FROM
		train
) b
WHERE
	t.n >= 100
ORDER BY
	t.ag,
	t.as_;

-- 6.2 年龄段 × 收入层级
SELECT
	COALESCE (t.ag, '合计') AS 年龄段,
	COALESCE (t.il, '小计') AS 收入层级,
	t.n AS 样本量,
	t.bad AS 违约数,
	round(100 * t.bad / t.nl, 2) AS 违约率,
	round((t.bad / t.nl) / b.base_rate, 2) AS lift
FROM
	(
		SELECT
			age_group AS ag,
			income_level AS il,
			count(*) AS n,
			count(label) AS nl,
			sum(label) AS bad
		FROM
			train_feat
		GROUP BY
			age_group,
			income_level WITH ROLLUP
	) t
CROSS JOIN (
	SELECT
		avg(label) AS base_rate
	FROM
		train
) b
WHERE
	t.n >= 100
ORDER BY
	t.ag,
	t.il;

-- 6.3 资产组合 × 收入层级
SELECT
	COALESCE (t.as_, '合计') AS 资产组合,
	COALESCE (t.il, '小计') AS 收入层级,
	t.n AS 样本量,
	t.bad AS 违约数,
	round(100 * t.bad / t.nl, 2) AS 违约率,
	round((t.bad / t.nl) / b.base_rate, 2) AS lift
FROM
	(
		SELECT
			asset_status AS as_,
			income_level AS il,
			count(*) AS n,
			count(label) AS nl,
			sum(label) AS bad
		FROM
			train_feat
		GROUP BY
			asset_status,
			income_level WITH ROLLUP
	) t
CROSS JOIN (
	SELECT
		avg(label) AS base_rate
	FROM
		train
) b
WHERE
	t.n >= 100
ORDER BY
	t.as_,
	t.il;
car_ownership, 
asset_status, 
label 
FROM train 
LIMIT 10;
