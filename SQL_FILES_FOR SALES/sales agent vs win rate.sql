
-- sales agent vs win rate
select sales_agent,
count(case when deal_stage = 'Won' then 1 end)as won_cnt,
count(opportunity_id) as total_cnt,
CAST(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) * 100.0 / COUNT(*) 
        AS DECIMAL(6,2)
    ) AS win_rate_percentage

    from sales_pipeline
    group by sales_agent order by  win_rate_percentage asc 
