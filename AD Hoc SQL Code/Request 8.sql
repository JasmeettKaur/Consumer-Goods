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
