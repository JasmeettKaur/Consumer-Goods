/* 7) Get the complete report of the Gross sales amount for the customer  “Atliq  Exclusive”  for each month .  
This analysis helps to  get an idea of low and  high-performing months and take strategic decisions. 
 The final report contains these columns:  Month  Year  Gross sales Amount */
 
select Monthname(fs.date) as Month, fg.fiscal_year, ROUND(SUM(fg.gross_price*fs.sold_quantity), 2) AS Gross_sales_Amount
from fact_sales_monthly as fs join fact_gross_price as fg 
on fs.product_code = fg.product_code 
join dim_customer as c
 on c.customer_code = fs.customer_code
where c.customer = 'atliq exclusive'
group by Month, fg.fiscal_year
order by  fg.fiscal_year, gross_sales_amount desc ;
