use gdb023;
show tables;

/* 1) Provide the list of markets in which customer  "Atliq  Exclusive"  operates its  business in the  APAC  region. */

select * from dim_customer;
select market from dim_customer where customer = 'Atliq Exclusive' and region = 'APAC';

/* 2) What is the percentage of unique product increase in 2021 vs. 2020? The  final output contains these fields,  
unique_products_2020  unique_products_2021  percentage_chg */

select * from dim_product;
select * from fact_gross_price;
SELECT
    SUM(CASE WHEN fiscal_year = 2020 THEN 1 ELSE 0 END) AS unique_products_2020,
    SUM(CASE WHEN fiscal_year = 2021 THEN 1 ELSE 0 END) AS unique_products_2021,
    ROUND(((SUM(CASE WHEN fiscal_year = 2021 THEN 1 ELSE 0 END) - SUM(CASE WHEN fiscal_year = 2020 THEN 1 ELSE 0 END)) / 
           SUM(CASE WHEN fiscal_year = 2020 THEN 1 ELSE 0 END)) * 100, 2) AS percentage_chg
FROM
    fact_gross_price
WHERE
    fiscal_year IN (2020, 2021);
    
/* 3) Provide a report with all the unique product counts for each  segment  and  sort them in descending order of product counts. 
   The final output contains fields,  segment  product_count */
   
select * from dim_product;
select segment, count(distinct(product_code)) as product_count 
 from dim_product
 group by segment
 order by product_count desc;
 
/* 4) Which segment had the most increase in unique products in 
 2021 vs 2020? The final output contains these fields,  segment  product_count_2020  product_count_2021  difference */
 
 SELECT
    p.segment,
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2020 THEN p.product_code END) AS product_count_2020,
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2021 THEN p.product_code END) AS product_count_2021,
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2021 THEN p.product_code END) -
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2020 THEN p.product_code END) AS difference
FROM
   dim_product p
JOIN
    fact_sales_monthly fs ON p.product_code = fs.product_code
GROUP BY
    p.segment;
    
/* 5) Get the products that have the highest and lowest manufacturing costs.  
The final output should contain these fields,  product_code  product  manufacturing_cost */

SELECT
    d.product_code,
    d.product,
    f.manufacturing_cost
FROM
    dim_product d
JOIN
    fact_manufacturing_cost f ON d.product_code = f.product_code
WHERE
    f.manufacturing_cost = (
        SELECT MAX(manufacturing_cost)
        FROM fact_manufacturing_cost
    )
    OR
    f.manufacturing_cost = (
        SELECT MIN(manufacturing_cost)
        FROM fact_manufacturing_cost
    );

/* 6) Generate a report which contains the top 5 customers who received an  average high 
 pre_invoice_discount_pct  for the  fiscal  year 2021  and in the  Indian  market. 
 The final output contains these fields,  customer_code  customer  average_discount_percentage */
 
select c.customer_code, c.customer, fp.pre_invoice_discount_pct from dim_customer as c join fact_pre_invoice_deductions as fp 
on c.customer_code = fp.customer_code 
where fp.pre_invoice_discount_pct > (select avg(pre_invoice_discount_pct) from fact_pre_invoice_deductions)
and
c.market = 'india' and fp.fiscal_year = 2021
order by
pre_invoice_discount_pct desc
limit 5;

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

/* 8) In which quarter of 2020, got the maximum total_sold_quantity? The final  output contains these fields sorted by the total_sold_quantity, 
 Quarter  total_sold_quantity */
 
select concat('Q', CASE
    WHEN date BETWEEN '2019-09-01' AND '2019-11-01' then 1  
    WHEN date BETWEEN '2019-12-01' AND '2020-02-01' then 2
    WHEN date BETWEEN '2020-03-01' AND '2020-05-01' then 3
    WHEN date BETWEEN '2020-06-01' AND '2020-08-01' then 4
    END ) as Quarter, sum(sold_quantity) as total_sold_quantity from fact_sales_monthly 
where fiscal_year = 2020 
group by quarter
order by total_sold_quantity desc;

/* 9) Which channel helped to bring more gross sales in the fiscal year 2021  and the percentage of contribution?  The final output  contains these fields, 
  channel  gross_sales_mln  percentage */
 
 WITH Output AS
(
SELECT C.channel,
       ROUND(SUM(G.gross_price*FS.sold_quantity/1000000), 2) AS Gross_sales_mln
FROM fact_sales_monthly FS JOIN dim_customer C ON FS.customer_code = C.customer_code
						   JOIN fact_gross_price G ON FS.product_code = G.product_code
WHERE FS.fiscal_year = 2021
GROUP BY channel
)
SELECT channel, CONCAT(Gross_sales_mln,' M') AS Gross_sales_mln , CONCAT(ROUND(Gross_sales_mln*100/total , 2), ' %') AS percentage
FROM
(
(SELECT SUM(Gross_sales_mln) AS total FROM Output) A,
(SELECT * FROM Output) B
)
ORDER BY percentage DESC ;
 
 
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

 
 
 
 
 















