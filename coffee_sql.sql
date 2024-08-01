SELECT * FROM coffee_database.coffee_sales;
SELECT DISTINCT
    (transaction_date)
FROM
    coffee_sales;
SELECT DISTINCT
    (store_location)
FROM
    coffee_sales;
SELECT 
    COUNT(*)
FROM
    coffee_sales;
describe coffee_sales;
-- here we are updating the format of transaction date column type from text to date--
UPDATE coffee_sales 
SET 
    transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');   -- format of typing query for changing it.

ALTER TABLE coffee_sales
modify column transaction_date DATE; -- this is to convert them into date datatype
 
describe coffee_sales;
-- this is to define the format of time hours
UPDATE coffee_sales 
SET 
    transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffee_sales
modify column transaction_time TIME;

describe coffee_sales;
select * from coffee_sales;
-- total sales
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS totalsales
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 3;
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS totalsales
FROM
    coffee_sales;
-- sales comparison BETWEEN THIS MONTH AND PREVIOUS MONTH
select
    month(transaction_date) as month,
    round(sum(transaction_qty * unit_price)) as total_sales,
    (sum(transaction_qty * unit_price) - LAG(sum(transaction_qty * unit_price), 1)
    OVER (ORDER BY MONTH (transaction_date))) / LAG(sum(transaction_qty * unit_price), 1)
    OVER (ORDER BY MONTH (transaction_date)) * 100 as percentage
from coffee_sales
where month(transaction_date) in (1,2)
group by month(transaction_date)
order by month(transaction_date);
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (1, 2) 
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
-- total orders
SELECT 
    COUNT(transaction_id) AS totalorder
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 2;
select month(transaction_date) as month,count(transaction_id) as total_orders,
(count(transaction_id) - lag(count(transaction_id),1)
over (order by month(transaction_date))) / lag(count(transaction_id),1)
over (order by month(transaction_date)) * 100 as percentage
from coffee_sales
where month(transaction_date) in (1,2)
group by month(transaction_date)
order by month(transaction_date);
-- total quantity sold by each month
SELECT 
    MONTHNAME(transaction_date) AS months,
    SUM(transaction_qty) AS total_qty
FROM
    coffee_sales
GROUP BY months; 
-- comaparison
select month(transaction_date) as months, sum(transaction_qty) as total_quantity,
(sum(transaction_qty) - lag(sum(transaction_qty),1)
over (order by month(transaction_date)))/ lag(sum(transaction_qty),1)
over (order by month(transaction_date)) * 100 as pct
from coffee_sales
where month(transaction_date) in (2,3)
group by month(transaction_date)
order by month(transaction_date);
-- sales according to particular day
SELECT 
    transaction_date,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales,
    SUM(transaction_qty) AS total_qty_sold,
    COUNT(transaction_id) AS total_orders
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 3
GROUP BY transaction_date;
-- for weekdays and weekend
SELECT 
    CASE
        WHEN DAYOFWEEK(transaction_date) IN (1 , 7) THEN 'weekends'
        ELSE 'weekdays'
    END AS day_type,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 2
GROUP BY day_type;
select * from coffee_sales;
SELECT 
    store_location,
    ROUND(SUM(transaction_qty * unit_price), 2) AS sales
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 2
GROUP BY store_location;
-- daily sales
SELECT 
    transaction_date,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales
FROM
    coffee_sales
WHERE
    MONTHNAME(transaction_date) = 'february'
GROUP BY transaction_date;
-- average sales
SELECT 
    ROUND(SUM(transaction_qty * unit_price) / COUNT(DISTINCT (transaction_date)),
            2) AS avg_sales
FROM
    coffee_sales
WHERE
    MONTHNAME(transaction_date) = 'february';
-- comparison 
SELECT 
    AVG(sales) AS avg_sales
FROM
    (SELECT 
        SUM(transaction_qty * unit_price) AS sales
    FROM
        coffee_sales
    WHERE
        MONTH(transaction_date) = 2
    GROUP BY transaction_date) AS news;
select * from coffee_sales;
select transaction_date, total_sales,avg_sales,
case
when total_sales > avg_sales then 'ABOVE' 
when total_sales < avg_sales then 'BELOW'
else 'equal'
end as performance
from
(
select transaction_date,sum(transaction_qty * unit_price) as total_sales,
avg(sum(transaction_qty * unit_price)) over() as avg_sales
from coffee_sales
where month(transaction_date)=3
group by transaction_date) as march;
-- BY PRODUCT CATEGORY
SELECT 
    product_category,
    ROUND(SUM(transaction_qty * unit_price)) AS total_sales
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 2
GROUP BY product_category
ORDER BY total_sales DESC;
-- by product type
select * from coffee_sales;
SELECT 
    product_type,
    ROUND(SUM(transaction_qty * unit_price)) AS total_sales
FROM
    coffee_sales
WHERE
    MONTH(transaction_date) = 1
GROUP BY product_type
ORDER BY total_sales DESC
LIMIT 10;
-- by hour
select * from coffee_sales;
SELECT 
    HOUR(transaction_time) AS Hours,
    ROUND(SUM(transaction_qty * unit_price)) AS total_sales,
    SUM(transaction_qty) AS total_qty,
    COUNT(transaction_id) AS total_orders
FROM
    coffee_sales
GROUP BY hours;
select dayname(transaction_date) as dayname,round(sum(transaction_qty*unit_price)) as sales
from coffee_sales
group by dayname(transaction_date)
order by dayname(transaction_date) asc ;
-- by dayname but in ascending order
select
case
when dayofweek(transaction_date) = 2 then 'Monday'
when dayofweek(transaction_date) = 3 then 'Tuesday'
when dayofweek(transaction_date) = 4 then 'Wednesday'
when dayofweek(transaction_date) = 5 then 'Thursday'
when dayofweek(transaction_date) = 6 then 'Friday'
when dayofweek(transaction_date) = 7 then 'Saturday'
else 'Sunday'
end as Days,
sum(transaction_qty * unit_price) as total_sales
from coffee_sales
where month(transaction_date)=2
group by case
when dayofweek(transaction_date) = 2 then 'Monday'
when dayofweek(transaction_date) = 3 then 'Tuesday'
when dayofweek(transaction_date) = 4 then 'Wednesday'
when dayofweek(transaction_date) = 5 then 'Thursday'
when dayofweek(transaction_date) = 6 then 'Friday'
when dayofweek(transaction_date) = 7 then 'Saturday'
else 'Sunday'
end;
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) = 2 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;












































