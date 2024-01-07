use gdb023;
show tables;

/* 1) Provide the list of markets in which customer  "Atliq  Exclusive"  operates its  business in the  APAC  region. */

select * from dim_customer;
select market from dim_customer where customer = 'Atliq Exclusive' and region = 'APAC';
