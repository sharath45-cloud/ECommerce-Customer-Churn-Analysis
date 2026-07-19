--data overviewe--
select*from ecommerce_churn;

--this query use is count of gender 
select gender,count(*) from ecommerce_churn group by gender;

select*from ecommerce_churn where CityTier=3;
--citytier breakdown analysis--
--this query counts the no of customers in each city tier(1,2,3)--
select CityTier,count(*) from ecommerce_churn group by cityTier;

--this query counts customers using device count--
select PreferredLoginDevice,count(*) from ecommerce_churn group by PreferredLoginDevice;
select max(PreferredLoginDevice) from ecommerce_churn;

--this query helps to convert the same columns into one colomn and adding the total values in one colomn-
select 
    case 
    when lower(preferredlogindevice) = 'phone' then 'Mobile Phone'
    when lower(preferredlogindevice) = 'mobile phone' then 'Mobile Phone'
    else preferredlogindevice 
    end as device_type,
    count(*) 
    from ecommerce_churn 
    group by
    case 
    when lower(preferredlogindevice) = 'phone' then 'Mobile Phone'
    when lower(preferredlogindevice) = 'mobile phone' then 'Mobile Phone'
    else preferredlogindevice 
    end;


--leaving customers churn_rate_percentage on e-commerce_churn--
--use:this query calculates the overall percentage of customers who stopped using the service.
--it helps the business understand the scale of customers loss--
select 
count(*) as total_customers,
sum(churn)as churned_custemers,
round((sum(churn)::Numeric/count(*)) * 100,2)as churn_rate_percentage
from ecommerce_churn;


--complaints vs churn rate analysis--
--use:this query checks if customers who raised complaints are leaving the company more others--
--it helps the business identify if customers service issues are drivig the churn--
select
complain,
count(*) as total_custemers,
sum(churn) as churned_custemrs,
round((sum(churn)::Numeric/count(*))* 100,2)as churn_rate
from ecommerce_churn
group by complain;


-- This query calculates the average number of months customers stayed before churning compared to active customers--
select
churn,(avg(tenure),1) as average_months_stayed
from ecommerce_churn
group by churn;


-- Average Warehouse Distance for Churned Customers---
--This query checks if customers who left lived farther away from the warehouse on average--
-- It helps identify if delivery distance and potential delays are causing customers to churn--
SELECT 
churn, (AVG(warehousetohome), 1) AS avg_distance_from_warehouse
FROM ecommerce_churn
GROUP BY churn;

select count(customerid) as total_customers from ecommerce_churn;


  