-- How is each sales team performing compared to the rest?
SELECT 
    T.manager AS TEAM,
    COUNT(CASE WHEN S.deal_stage = 'Won' THEN 1 END) AS won_deals,
    COUNT(*) AS total_team_deals,
    CAST(
        COUNT(CASE WHEN S.deal_stage = 'Won' THEN 1 END) * 100.0 / COUNT(*) 
        AS DECIMAL(5,2)
    ) AS win_rate_percentage
FROM sales_pipeline S
JOIN sales_teams T ON S.sales_agent = T.sales_agent
GROUP BY T.manager
ORDER BY win_rate_percentage DESC;
