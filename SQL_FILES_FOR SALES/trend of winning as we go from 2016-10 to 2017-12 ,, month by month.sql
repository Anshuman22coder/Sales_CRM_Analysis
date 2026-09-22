-- trend of winning as we go from 2016-10 to 2017-12 ,, month by month


SELECT 
    FORMAT(engage_date, 'yyyy-MM') AS engage_month,
    COUNT(*) AS won_deals
FROM sales_pipeline
WHERE deal_stage = 'Won'
  AND engage_date >= '2016-10-01'
  AND engage_date <  '2018-01-01'
GROUP BY FORMAT(engage_date, 'yyyy-MM')
ORDER BY engage_month;                              
