select count(`Order ID`) as `Total Order`,
sum(Sales) as `Total Sale`,
sum(Profit) as `Total Profit`,
sum(Quantity) as `Total Quantity` ,
sum(Sales)/ count(`Order ID`) as `Avg Order Value` from retail_analytics.cleaned_superstore;

select `Product Name`, sum(Sales) as `Total Sales`
from retail_analytics.cleaned_superstore
group by `Product Name` 
order by `Total Sales` desc
limit 5;

select `Product Name`, sum(Profit) as `Total Profit`
from retail_analytics.cleaned_superstore
group by `Product Name`
order by `Total Profit` desc
limit 5;

select `Product Name`, sum(Profit) as `Total Profit`
from retail_analytics.cleaned_superstore
group by `Product Name`
order by `Total Profit` asc
limit 5;

select `Product Name`, sum(Quantity) as `Total Quantity`
from retail_analytics.cleaned_superstore
group by `Product Name`
order by `Total Quantity` desc
limit 5;

select Category, sum(Profit) as `Total Profit`, sum(Sales) as  `Total Sales`
from retail_analytics.cleaned_superstore
group by Category
order by `Total Profit`, `Total Sales` desc;

select Region, sum(Profit) as `Total Profit`, sum(Sales) as  `Total Sales`
from retail_analytics.cleaned_superstore
group by Region
order by `Total Profit`, `Total Sales` desc;

select Segment, sum(Profit) as `Total Profit`, sum(Sales) as  `Total Sales`
from retail_analytics.cleaned_superstore
group by Segment
order by `Total Profit`, `Total Sales` desc;

select `City`, sum(Sales) as `Total Sale`
from retail_analytics.cleaned_superstore
group by `City`
order by `Total Sale` desc
limit 5;

select `Discount Level`, count(`Order ID`) as `Total Order`, avg(Profit) as `Average Profit` , sum(Profit) as `Total Profit`
from retail_analytics.cleaned_superstore
group by `Discount Level`
order by `Total Order` , `Average Profit` , `Total Profit`;

select `Order ID`, Discount, `Product Name`, Profit
from retail_analytics.cleaned_superstore
where `Discount Level` = "High Discount" and Profit < 0;

select `Delivery Speed`, count(`Order ID`) as `Total Order`, sum(Sales) as `Total Sale` , sum(Profit) as `Total Profit`
from retail_analytics.cleaned_superstore
group by `Delivery Speed`
order by `Total Order` , `Total Sale` , `Total Profit`;

select Segment, sum(Profit) as `Total Profit`
from retail_analytics.cleaned_superstore
group by Segment 
order by `Total Profit`;

select `Order Month Name`, sum(Sales) as `Total Sale`, sum(Profit) as `Total Profit`
from retail_analytics.cleaned_superstore
group by `Order Month Name`,`Order Month Number`
order by `Order Month Number`;

select `Order Month Name`, sum(Sales) as `Total Sale`, sum(Profit) as `Total Profit` 
from retail_analytics.cleaned_superstore
group by `Order Month Name`
order by `Total Profit` desc
limit 1;

select `Order Month Name`, `Total Sale`,
lag (`Total Sale`) over(order by `Order Month Number`) as `Previous Month Sales`,
`Total Sale` - lag(`Total Sale`) over (order by `Order Month Number`) as Growth
from(
	select `Order Month Name`, `Order Month Number`, sum(Sales) as `Total Sale`
from retail_analytics.cleaned_superstore
group by `Order Month Name`, `Order Month Number`
)t;

select * from
(
select Region, `Customer Name`, sum(Sales) as `Total Sale`, row_number() 
over (partition by Region order by sum(Sales) desc) as `Rank`
from retail_analytics.cleaned_superstore
group by Region, `Customer Name`
) t
where `Rank` <= 3;

select Category, sum(Sales) as `Total Sale`, 
(sum(Sales)/(select sum(Sales) from retail_analytics.cleaned_superstore))* 100 as `Percentage Contribution`
from retail_analytics.cleaned_superstore
group by Category
order by `Total Sale`, `Percentage Contribution`;

select `Discount Level`, Profit, `Delivery Speed` 
from retail_analytics.cleaned_superstore
where `Discount Level` = "High Discount" 
and Profit < 0 
and `Delivery Speed` = "Slow Delivery";

select * from
(
select `Product Name`, Category, sum(sales) as `Total Sales` , row_number()
over (partition by Category order by sum(Sales)desc) as `Rank`
from retail_analytics.cleaned_superstore
group by Category ,`Product Name`
)t
where `Rank` <=3 ;

create view `Monthly Summary View` as
select `Order Month Number`, `Order Month Name`,  
sum(Sales) as `Total Sale`, sum(Profit) as `Total Profit`, sum(Quantity) as `Total Qantity`
from retail_analytics.cleaned_superstore
group by `Order Month Name`, `Order Month Number`;
SELECT * FROM retail_analytics.`monthly summary view`;

create view `Discount Profit View` as 
select `Discount Level`, count(`Order ID`), 
sum(Sales) as `Total Sale` , sum(Profit) as `Total Profit`, avg(Profit) as `Average Profit`
from retail_analytics.cleaned_superstore
group by `Discount Level`;
SELECT * FROM retail_analytics.`discount profit view`;

Delimiter &&
create procedure get_Region_Report(in `Region Name` varchar(50))
begin
	select Region, sum(`Order ID`) as `Total Orders`, sum(Sales) as `Total Sale`,
	sum(Profit) as `Total Profit`, avg(`Shipping Days`) as `Average Shipping Days`
	from retail_analytics.cleaned_superstore 
    where Region = `Region Name`
    group by Region;
End && 
Delimiter &&;
call get_Region_Report("West");