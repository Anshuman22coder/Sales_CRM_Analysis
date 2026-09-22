-- select * from sales_pipeline
-- deal Won percenatge
select
cast
(count(*)*100.0 /(select count(*) from sales_pipeline) 
as decimal(4,2))
as won_no
from sales_pipeline where deal_stage= 'Won'