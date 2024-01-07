/* 5) Get the products that have the highest and lowest manufacturing costs.  
The final output should contain these fields,  product_code  product  manufacturing_cost */

SELECT d.product_code, d.product, f.manufacturing_cost
FROM dim_product d
JOIN  fact_manufacturing_cost f ON d.product_code = f.product_code
WHERE f.manufacturing_cost = ( SELECT MAX(manufacturing_cost)
 FROM fact_manufacturing_cost )
 OR f.manufacturing_cost = ( SELECT MIN(manufacturing_cost)FROM fact_manufacturing_cost);
