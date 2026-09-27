use BankChurn;

-- churned rate  by gender
with cte as (
select  
Gender, 
count(CustomerId) as TotalCustomers,
sum(cast(Churned as int)) as ChurnedCustomers
from demographic
group by Gender
) 

select * , Format((ChurnedCustomers*100 /TotalCustomers), 'N2') + '%'  as ChurnedRate
from cte





-- How does Churn rate vary across customer segments within each region

with cte1 as
(
select 
case 
     when d.age < 30 then 'under 30'
     when d.age between 30 and 50 then 'between 30-50'
     else 'above 50'
end as AgeGroup,
d.CustomerId as CustomerId,
d.Churned as Churned,
l.Geography as Country 
from 
demographic as d 
join location as l
on d.LocationId = l.LocationId
)


select 
Country,
AgeGroup,
count(CustomerId) as TotalCustomers,
sum(cast(Churned as int)) as ChurnedCustomers,
format(avg(cast (Churned as Float)),'N2')+ '%' as AvgChurnedRate,
format(avg(avg(cast (Churned as Float))) over(partition by Country),'N2') + '%' 

as AvgChurnedRateCountry

from cte1
group by Country, AgeGroup
order by Country, AgeGroup



--how does churn behavior change when we dynamically slice  cutsomers by business parameters?
-- The Parameters :
-- Tenure , NumofProducts , Balance


declare @MinTenure int = 9; 
declare @MaxBalance int = 100000;
declare @MaxNumofProducts int = 5;
 
select 
d.CustomerId,
a.Tenure,
a.Balance,
a.NumProducts,
d.Churned
from demographic as d
join account as a
on d.CustomerId = a.CustomerId
where 
tenure > @MinTenure
and
Balance < @MaxBalance
and
NumProducts < @MaxNumofProducts




