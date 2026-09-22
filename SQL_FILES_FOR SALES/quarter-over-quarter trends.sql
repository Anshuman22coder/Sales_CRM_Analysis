-- Are there any quarter-over-quarter trends?

SELECT 
    CONCAT(YEAR(engage_date), '-Q', DATEPART(QUARTER, engage_date)) AS engage_quarter,
    COUNT(*) AS WON
FROM sales_pipeline 
WHERE deal_stage = 'Won'
  AND engage_date IS NOT NULL
GROUP BY 
    CONCAT(YEAR(engage_date), '-Q', DATEPART(QUARTER, engage_date)),
    YEAR(engage_date),
    DATEPART(QUARTER, engage_date)  -- this year and datepart grouping is done onky for ordering, as if this is not used then the order by will not be possible
ORDER BY 
    YEAR(engage_date),
    DATEPART(QUARTER, engage_date);
   
