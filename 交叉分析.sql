SELECT 
asset_status AS '资产组合',
COUNT(*) AS '总人数',
ROUND(AVG(label) * 100, 2) AS '违约率百分比'
FROM train
GROUP BY asset_status
ORDER BY 资产组合;

SELECT 
income_level AS '收入层级',
COUNT(*) AS '总人数',
ROUND(AVG(label) * 100, 2) AS '违约率百分比'
FROM train
GROUP BY income_level
ORDER BY 收入层级;

SELECT  
age_group AS '年龄段',
COUNT(*) AS '总人数',
ROUND(AVG(label) * 100, 2) AS '违约率百分比'
FROM train
GROUP BY age_group
ORDER BY 年龄段;

SELECT ROUND(AVG(label) * 100, 2) AS 整体基准违约率 
FROM train;

SELECT 
age_group AS 年龄段,
asset_status AS 资产组合,
COUNT(*) AS 样本量,
ROUND(AVG(label) * 100, 2) AS 违约率
FROM train
GROUP BY age_group, asset_status
HAVING COUNT(*) >= 100
ORDER BY 违约率 DESC;

SELECT 
age_group AS 年龄段,
income_level AS 收入层级,
COUNT(*) AS 样本量,
ROUND(AVG(label) * 100, 2) AS 违约率
FROM train
GROUP BY age_group,income_level
HAVING COUNT(*) >= 100
ORDER BY 违约率 DESC;

SELECT 
asset_status AS 资产组合,
income_level AS 收入层级,
COUNT(*) AS 样本量,
ROUND(AVG(label) * 100, 2) AS 违约率
FROM train
GROUP BY asset_status,income_level
HAVING COUNT(*) >= 100
ORDER BY 违约率 DESC;
