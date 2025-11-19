create database retail_analytics;

use retail_analytics;

drop database retail_analytics;

select * from sales_transaction;
select * from customer_profiles;
select * from product_inventory;

alter table sales_transaction
rename column ï»¿TransactionID to TransactionID;

alter table customer_profiles
rename column ï»¿CustomerID to CustomerID;

alter table product_inventory
rename column ï»¿ProductID to ProductID;


-- Write a query to identify the number of duplicates in "sales_transaction" table.
--  Also, create a separate table containing the unique values and remove the the original table 
--  from the databases and replace the name of the new table with the original name.

select transactionID, count(*)
from sales_transaction
group by transactionID
having count(*) > 1;

create table sales_transaction_unique
as select distinct * from sales_transaction;

drop table sales_transaction;

alter table sales_transaction_unique rename to sales_transaction;

select * from sales_transaction;

-- Write a query to identify the discrepancies in the price of the same product in "sales_transaction" and 
-- "product_inventory" tables. Also, update those discrepancies to match the price in both the tables.

select TransactionID, s.price as TransactionPrice, p.price as InventoryPrice
from sales_transaction s  
join product_inventory p on s.ProductID = p.ProductID
where s.price <> p.price;

set sql_safe_updates = 0;

update sales_transaction s
join product_inventory p on s.ProductID = p.ProductID
set s.price = p.price
where s.price <> p.price;

select * from sales_transaction;

-- Write a SQL query to identify the null values in the dataset and replace those by “Unknown”.

select count(*) from customer_profiles
where location = '';

update customer_profiles
set location = 'unknown'
where location = '';

select * from customer_profiles;

-- Write a SQL query to clean the DATE column in the dataset.

create table Sales_transaction_update as
select *, 
          date(TransactionDate) as TransactionDate_updated
from Sales_transaction;

drop table Sales_transaction;

alter table Sales_transaction_update
rename to Sales_transaction;

select * from Sales_transaction;

-- Write a SQL query to summarize the total sales and quantities sold per product by the company.
-- (Here, the data has been already cleaned in the previous steps and from here we will be understanding
--  the different types of data analysis from the given dataset.)

select productID,
        sum(quantityPurchased) as TotalUnitssold,
        sum(price * quantityPurchased) as TotalSales
from Sales_transaction
group by productID
order by TotalSales desc;

-- Write a SQL query to count the number of transactions per customer to understand purchase frequency.

select CustomerID,
          count(*) as NumberOfTransactions
from sales_transaction
group by CustomerID
order by NumberOfTransactions desc;

-- Write a SQL query to evaluate the performance of the product categories based on the total sales which help us
--  understand the product categories which needs to be promoted in the marketing campaigns.

select p.category,
          sum(s.quantityPurchased) as TotalUnitsSold,
          sum(s.quantityPurchased * s.price) as TotalSales
from sales_transaction s 
join product_inventory p on s.productId = p.productId
group by p.category
order by TotalSales desc;

-- Write a SQL query to find the top 10 products with the highest total sales revenue from the sales transactions. 
-- This will help the company to identify the High sales products which needs to be focused to increase the revenue 
-- of the company.

select productId,
          round(sum(price * quantityPurchased),2) as TotalRevenue
from sales_transaction
group by productId
order by TotalRevenue desc
limit 10;

-- Write a SQL query to find the ten products with the least amount of units sold from the sales transactions,
--  provided that at least one unit was sold for those products.

select ProductID,
          sum(quantityPurchased) as TotalUnitsSold
from sales_transaction
group by productId
having TotalUnitsSold > 0
order by TotalUnitsSold asc
limit 10;

-- Write a SQL query to identify the sales trend to understand the revenue pattern of the company.

select date(transactiondate) as DATETRANS,
               count(*) as Transaction_count,
               sum(quantityPurchased) as TotalUnitsSold,
               round(sum(price * quantityPurchased),2) as TotalSales
from sales_transaction
group by DATETRANS
order by DATETRANS desc;

-- Write a SQL query to understand the month on month growth rate of sales of the company which will 
-- help understand the growth trend of the company.

with ranked as (
        select month(transactiondate) as month,
        round(sum(price*quantityPurchased),2) as total_sales
        from sales_transaction
        group by month
)
select month, total_sales,
           round(
				  lag(total_sales) over (order by month)
				,2) as previous_month_sales,
           round(
                  ((total_sales - lag(total_sales) over (order by month))
                     / lag(total_sales) over (order by month))
               * 100,2) as mom_growth_percentage
from ranked;


-- Write a SQL query that describes the number of transaction along with the total amount spent by 
-- each customer which are on the higher side and will help us understand the customers who are the
--  high frequency purchase customers in the company.
-- The resulting table must have number of transactions more than 10 and TotalSpent more than 1000 on those transactions
--  by the corresponding customers.

select CustomerID,
          count(*) as NumberOfTransactions,
        sum(price * quantityPurchased) as TotalSpent
from sales_transaction
group by CustomerID
having NumberOfTransactions > 10 and TotalSpent > 1000
order by TotalSpent desc;

-- Write a SQL query that describes the number of transaction along with the total amount spent by each customer,
--  which will help us understand the customers who are occasional customers or have low purchase frequency in the company.
-- The resulting table must have number of transactions less than or equal to 2 and corresponding total amount spent on those
--  transactions by related customers.

select CustomerID,
          count(*) as NumberOfTransactions,
        sum(price * quantityPurchased) as TotalSpent
from sales_transaction
group by CustomerID
having NumberOfTransactions <= 2 
order by NumberOfTransactions ,TotalSpent desc;

-- Write a SQL query that describes the total number of purchases made by each customer against each
-- productID to understand the repeat customers in the company.

select  CustomerID, ProductID,
           count(*) as TimesPurchased
from sales_transaction
group by CustomerID, ProductID
having TimesPurchased > 1
order by TimesPurchased desc;

-- Write a SQL query that describes the duration between the first and the last purchase of the customer in 
-- that particular company to understand the loyalty of the customer.

select CustomerID,
           min(date(transactionDate)) as FirstPurchase,
           max(date(transactionDate)) as LastPurchase,
           datediff(max(date(transactionDate)), min(date(transactionDate))) as DaysBetweenPurchases
from Sales_transaction
group by CustomerID
having DaysBetweenPurchases > 0
order by DaysBetweenPurchases desc;

-- Write an SQL query that segments customers based on the total quantity of products they have purchased. 
-- Also, count the number of customers in each segment which will help us target a particular segment for marketing.

create table customer_segment as 
     select  c.customerID,
             case
                when sum(QuantityPurchased) <=10 then 'Low'
                when sum(QuantityPurchased) between 11 and 30 then 'Med'
                else 'High'
             end as CustomerSegment
     from sales_transaction s 
     join customer_profiles c on s.customerID = c.customerID
     group by customerID;

select CustomerSegment, count(*)
from customer_segment
group by CustomerSegment;