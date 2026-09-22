-- How is each sales team performing compared to the rest?
with sub as (select count(*) as cnt from sales_pipeline where deal_stage='won')

select count (*)TEAM

from sales_pipeline S
left join sales_teams T on (S.sales_agent=T.sales_agent)
where T.sales_agent is null

