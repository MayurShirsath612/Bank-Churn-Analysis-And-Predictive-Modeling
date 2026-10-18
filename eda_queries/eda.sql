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

--insights
-- Female customers have a higher churn rate (25%) than male customers (16%).
-- Despite having fewer customers, females account for more churned customers (1,139) than males (898).
--Female churn is 9 percentage points higher, suggesting that female customers may need more targeted retention efforts.



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

--insights 
--Customers above 50 have the highest churn rate across all countries, ranging from approximately 41% to 49%.
--Customers under 30 have the lowest churn rate, ranging from approximately 6% to 10%.
--The UK has the highest churn among customers above 50 (49%), followed by the USA (48%).
--Customers aged 30–50 show relatively consistent churn across countries, around 18%–20%.
--Age appears to be a stronger factor in churn than country, as the same age-group pattern appears across all six countries.




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



/*
Tenure: Check whether churn differs when you increase or decrease the minimum tenure.

Balance: Compare churn rates using different maximum balance thresholds.

Number of products: Check whether churn changes when filtering customers by the number of products they hold.

Combined effect: These parameters work together, so the resulting churn rate represents only customers who satisfy all three conditions.
*/
