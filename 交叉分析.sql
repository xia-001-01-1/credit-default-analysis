-- 3.交叉分析
-- 3.1 按资产组合看违约率
SELECT 
asset_status AS '资产组合',
COUNT(*) AS '总人数',
ROUND(AVG(label) * 100, 2) AS '违约率百分比'
FROM train
GROUP BY asset_status
ORDER BY 资产组合;

--3.2 按收入层级看违约率
SELECT 
income_level AS '收入层级',
COUNT(*) AS '总人数',
ROUND(AVG(label) * 100, 2) AS '违约率百分比'
FROM train
GROUP BY income_level
ORDER BY 收入层级;

-- 3.3 按年龄段看违约率
SELECT  
age_group AS '年龄段',
COUNT(*) AS '总人数',
ROUND(AVG(label) * 100, 2) AS '违约率百分比'
FROM train
GROUP BY age_group
ORDER BY 年龄段;

-- 3.4 整体基准违约率
SELECT ROUND(AVG(label) * 100, 2) AS 整体基准违约率 
FROM train;

--3.5 年龄段与资产组合交叉分析违约率
SELECT 
age_group AS 年龄段,
asset_status AS 资产组合,
COUNT(*) AS 样本量,
ROUND(AVG(label) * 100, 2) AS 违约率
FROM train
GROUP BY age_group, asset_status
HAVING COUNT(*) >= 100
ORDER BY 违约率 DESC;

-- 3.6 年龄段与收入层级交叉分析违约率
SELECT 
age_group AS 年龄段,
income_level AS 收入层级,
COUNT(*) AS 样本量,
ROUND(AVG(label) * 100, 2) AS 违约率
FROM train
GROUP BY age_group,income_level
HAVING COUNT(*) >= 100
ORDER BY 违约率 DESC;

-- 3.7 资产组合与收入层级交叉分析违约率
SELECT 
asset_status AS 资产组合,
income_level AS 收入层级,
COUNT(*) AS 样本量,
ROUND(AVG(label) * 100, 2) AS 违约率
FROM train
GROUP BY asset_status,income_level
HAVING COUNT(*) >= 100
ORDER BY 违约率 DESC;
