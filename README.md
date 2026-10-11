# 信贷违约风险多维度分析

## 项目背景：
基于16.8万条公开信贷数据，模拟风控分析场景，探索违约率与年龄、资产、收入的关系。

## 数据来源：
平台：和鲸社区
数据集名称：用户贷款违约预测
链接：https://www.heywhale.com/mw/project/6ac2161364b031b1282a903c
样本量：168,000条
目标变量：label（0=正常，1=违约）
主要字段：年龄、收入、房产、车产、职业、工作年限等
使用限制：公开数据集，仅用于学习分析，不代表真实业务数据。
  
## 使用工具
SQL：数据清洗、等频分箱、交叉分析
Excel：数据透视表、风险看板

## 核心发现
整体违约率12.31%
30岁以下收入与违约率呈U型非线性关系
无房无车群体违约率13.01%

### 不同资产组合的违约率：
<img width="508" height="289" alt="image" src="https://github.com/user-attachments/assets/df4aebe2-380e-4d91-a297-d2702ff49977" />
### 不同收入层级的违约率：
<img width="508" height="289" alt="image" src="https://github.com/user-attachments/assets/6a11f6c0-b7f3-4d17-b217-d0d8285fff70" />
### 不同年龄段的违约率：
<img width="504" height="288" alt="image" src="https://github.com/user-attachments/assets/c23461c1-9b16-4aca-98eb-9bb458e79c04" />
### 不同年龄段与资产组合的组合违约率：
<img width="449" height="230" alt="image" src="https://github.com/user-attachments/assets/9f6bd804-b7fb-485e-a98d-68bd3b46deab" />
### 不同年龄段与收入层级的组合违约率：
<img width="440" height="233" alt="image" src="https://github.com/user-attachments/assets/4e79fcaf-00a6-4a65-8fff-865765f23dc6" />
### 不同资产组合和收入层级的组合违约率：
<img width="456" height="234" alt="image" src="https://github.com/user-attachments/assets/dd73fb1b-b3e7-4c2b-aef3-a8c7b68b3975" />
## 策略建议：
对“30岁以下 + 收入<200w + 无车无房”人群加强收入核验、收紧审批。

## 局限说明：
公开数据探索性分析，结论为相关性，非因果推断。
