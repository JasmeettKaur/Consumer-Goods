/* 6) Generate a report which contains the top 5 customers who received an  average high 
 pre_invoice_discount_pct  for the  fiscal  year 2021  and in the  Indian  market. 
 The final output contains these fields,  customer_code  customer  average_discount_percentage */
 
select c.customer_code, c.customer, fp.pre_invoice_discount_pct
 from dim_customer as c join fact_pre_invoice_deductions as fp 
 on c.customer_code = fp.customer_code 
   where fp.pre_invoice_discount_pct > (select avg(pre_invoice_discount_pct) from fact_pre_invoice_deductions)
   and c.market = 'india' and fp.fiscal_year = 2021
    order by pre_invoice_discount_pct desc
     limit 5;
