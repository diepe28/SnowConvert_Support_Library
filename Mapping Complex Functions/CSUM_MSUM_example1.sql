-- examples taken from 
-- https://www.wisdomjobs.com/e-university/teradata-tutorial-212/cumulative-and-moving-sum-using-sum-over-6082.html

create table sales_table
(product_id int, 
 sale_date date,
daily_sales number(18,4))

insert into sales_table values
(3000,'2000-09-28',61301.77),
(1000,'2000-09-28',48850.40),
(2000,'2000-09-28',41888.88),
(3000,'2000-09-29',34509.13),
(1000,'2000-09-29',54500.22),
(2000,'2000-09-29',48000.00),
(2000,'2000-09-30',49850.03),
(3000,'2000-09-30',43868.86),
(1000,'2000-09-30',36000.07)

insert into sales_table values
(1000,'2000-10-01',40200.43),
(2000,'2000-10-01',54850.29),
(1000,'2000-10-02',32800.50),
(2000,'2000-10-02',36021.93),
(1000,'2000-10-03',64300.00),
(2000,'2000-10-03',43200.18),
(1000,'2000-10-04',54553.10),
(2000,'2000-10-04',32800.50)



select product_id, sale_date, daily_sales,
    SUM(Daily_Sales) OVER ( ORDER BY Product_Id, Sale_Date ROWS UNBOUNDED PRECEDING) as Like_CSUM,
    SUM(Daily_Sales) OVER ( ORDER BY Product_Id, Sale_Date ROWS 2 PRECEDING) as Like_MSUM
from sales_table
  WHERE  Product_ID BETWEEN 1000 and 2000