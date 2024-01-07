/* 4) Which segment had the most increase in unique products in 
 2021 vs 2020? The final output contains these fields,  segment  product_count_2020  product_count_2021  difference */
 
 SELECT
    p.segment,
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2020 THEN p.product_code END) AS product_count_2020,
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2021 THEN p.product_code END) AS product_count_2021,
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2021 THEN p.product_code END) -
    COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2020 THEN p.product_code END) AS difference
FROM dim_product p
JOIN fact_sales_monthly fs ON p.product_code = fs.product_code
GROUP BY p.segment;
