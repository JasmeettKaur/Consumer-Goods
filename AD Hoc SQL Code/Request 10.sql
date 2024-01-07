 /* 10) Get the Top 3 products in each division that have a high  total_sold_quantity in the fiscal_year 2021? The final output contains these  fields, 
  division  product_code  product  total_sold_quantity  rank_order */
  
with e as
(select p.division, p.product_code, p.product, sum(fs.sold_quantity) as total_sold_quantity
from dim_product as p join fact_sales_monthly as fs
on p.product_code = fs.product_code 
where fiscal_year = 2021
group by p.division, p.product_code, p.product),
 cte as (select division, product_code, total_sold_quantity, rank() OVER(PARTITION BY division ORDER BY Total_sold_quantity DESC) AS 'Rank_Order' 
 from e)
 select e.division, e.product_code, e.total_sold_quantity, cte.rank_order 
 from e join cte 
 on e.product_code = cte.product_code
 where cte.rank_order IN (1,2,3);
