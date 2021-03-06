create database casestudy1

use casestudy1

select * from customer

select * from prod_cat_info

select * from transactions

--DATA PREPARATION AND UNDERSTANDING

--1. WHAT IS THE TOTAL NUMBER OF ROWS IN EACH OF THE 3 TABLES IN THE DATABASE?
Select count(*) from  customer union select count(*) from prod_cat_info union select count(*) from transactions

--2. WHAT IS THE TOTAL NUMBER OF TRANSACTION THAT HAVE A RETURN?
select count(*)[Transaction returned] from transactions where qty<1

--3.AS YOU WOULD HAVE NOTICED, THE DATES PROVIDED ACCROSS THE DATASETS ARE NOT IN A CORRECT FORMAT . AS FIRST STEPS, PLS CONVERT THE DATA VARIABLES --INTO VALID DATA FORMATS BEFORE PROCEEDING AHEAD.
alter table customer alter column DOB date

--4. What is the time range of the transaction data available for analysis? Show the 
--output in number of days, months and years simultaneously in different columns.

select datediff(DAY,min(tran_date), max (tran_date)) from transactions

--5.WHICH PRODUCT CATEGORY DOES THE SUB-CATEGORY "DIY" BELONG TO?
select prod_cat[Product category] from prod_cat_info where prod_subcat='DIY'

--DATA ANALYSIS 

--1. Which channel is most frequently used for transactions? 
select top 1 Transactions.Store_type,count(*) from Transactions group by Transactions.Store_type order by count(Store_type)desc

--2. What is the count of Male and Female customers in the database?
select gender,count(*) from Customer group by gender having gender in ('m','f')

--3. From which city do we have the maximum number of customers and how many?
 select top 1 Customer.city_code, count(city_code)[No of customer] from Customer group by city_code order by city_code desc

--4. How many sub-categories are there under the Books category?
select distinct count(prod_subcat) from prod_cat_info where prod_cat='books'

--5. What is the maximum quantity of products ever ordered?  
select top 1 qty from Transactions order by qty desc

--6. What is the net total revenue generated in categories Electronics and Books? 
select  prod_cat_info.prod_cat,sum(transactions.total_amt) from prod_cat_info join Transactions on prod_cat_info.prod_cat_code=Transactions.prod_cat_code where prod_cat_info.prod_cat in ('electronics','books') group by prod_cat_info.prod_cat

--7. How many customers have >10 transactions with us, excluding returns?
select Customer.customer_Id from Customer join Transactions on Customer.customer_Id = Transactions.cust_id where Transactions.Qty>0
  group by Customer.customer_Id having count(Transactions.cust_id)>10

select cust_id from (select * from Transactions where Qty>0)as abc group by cust_id having count(cust_id)>10

--8. What is the combined revenue earned from the “Electronics” & “Clothing” 
--categories, from “Flagship stores”?  
select  prod_cat_info.prod_cat,sum(transactions.total_amt) from prod_cat_info join Transactions on prod_cat_info.prod_cat_code=Transactions.prod_cat_code  group by prod_cat_info.prod_cat having Transactions.Store_type='Flagship store' and prod_cat_info.prod_cat in ('electronics','clothing')

select sum(total_amt) from (select * from Transactions where Transactions.Store_type='Flagship store' and prod_cat_code=1) as abc

select * from prod_cat_info left join Transactions on prod_cat_info.prod_cat_code=Transactions.prod_cat_code order by prod_cat_info.prod_cat_code

select * from Transactions where Store_type='flagship store' and prod_cat_code=1

select prod_cat_info.prod_cat,prod_cat_info.prod_cat_code, count(Transactions.prod_cat_code) from prod_cat_info full join Transactions on prod_cat_info.prod_cat_code= Transactions.prod_cat_code where Transactions.Store_type='flagship store' group by prod_cat_info.prod_cat,prod_cat_info.prod_cat_code

select count(*),sum(Transactions.total_amt) from Transactions where prod_cat_code=1 and Store_type='flagship store'

select prod_cat_info.prod_cat,prod_cat_info.prod_cat_code, count(*) from (select * from Transactions where Transactions.Store_type='flagship store') as abc 

--9. What is the total revenue generated from “Male” customers in “Electronics” 
--category? Output should display total revenue by prod sub-cat.
select Customer.customer_Id, customer.Gender,prod_cat_info.prod_cat, sum(Transactions.total_amt) from Customer join Transactions on Customer.customer_Id=Transactions.cust_id where Customer.Gender='male' and Transactions.prod_cat_code=(select prod_cat_info.prod_cat_code from prod_cat_info where prod_cat='electronics') group by Customer.customer_Id, customer.Gender,prod_cat_info.prod_cat
 







