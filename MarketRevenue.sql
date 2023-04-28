--1  What is the total Revenue of the company this year?
--2  What is the total Revenue Performance YoY?
--3  What is the MoM Revenue Performance?
--4  What is the Total Revenue Vs Target performance for the Year?
--5  What is the Revenue Vs Target performance Per Month?


select * from dbo.ipi_account_lookup$
select * from dbo.ipi_Calendar_lookup$
select * from dbo.ipi_Opportunities_Data$
select * from dbo.['Revenue Data(Raw)$']
select * from dbo.['Targets Data(Raw)$']
select * from dbo.['Marketing Data(Raw)$']

--Revenue in FY21
-- Total Revenue
select SUM(Revenue) as Total_Revenue from dbo.['Revenue Data(Raw)$']
where Month_ID in
( 
select Distinct Month_ID from dbo.ipi_Calendar_lookup$
where [Fiscal Year]= 'FY21'
)

--1 Revenue by MonthID for FY21
select Month_ID, SUM(Revenue) as Total_Revenue from dbo.['Revenue Data(Raw)$']
where Month_ID in
( 
select Distinct Month_ID from dbo.ipi_Calendar_lookup$
where [Fiscal Year]= 'FY21'
)
Group by Month_ID


--2  What is the total Revenue Performance YoY?
-- Data over 6 months for FY21

select SUM(Revenue) as Total_Revenue21 from dbo.['Revenue Data(Raw)$']
where Month_ID in
( 
select Distinct Month_ID from dbo.ipi_Calendar_lookup$
where [Fiscal Year]= 'FY21'
)

-- Data over 12 months for FY20
select Month_ID, SUM(Revenue) as Total_Revenue20 from dbo.['Revenue Data(Raw)$']
where Month_ID in
( 
select Distinct Month_ID from dbo.ipi_Calendar_lookup$
where [Fiscal Year]= 'FY20'
)
Group by Month_ID

-- select only year to date for last year
-- select only 6 months corressponding to 6 months in FY21


select Distinct Month_ID - 12 from dbo.['Revenue Data(Raw)$'] 
where Month_ID in
(
select Distinct Month_ID from dbo.ipi_Calendar_lookup$
where [Fiscal Year]= 'FY21'
)

-- Revenue for 1st 6 months

select Month_ID, SUM(Revenue) as Total_Revenue20 from dbo.['Revenue Data(Raw)$']
where Month_ID in
	( 
		select Distinct Month_ID - 12 from dbo.['Revenue Data(Raw)$'] 
		where Month_ID in
					(
					select Distinct Month_ID from dbo.ipi_Calendar_lookup$
					where [Fiscal Year]= 'FY21'
					)
	)
	Group by Month_ID

-- Total Revenue generated year 20 for 1st 6 months

select SUM(Revenue) as Total_Revenue20 from dbo.['Revenue Data(Raw)$']
where Month_ID in
( 
	select Distinct Month_ID - 12 from dbo.['Revenue Data(Raw)$'] 
	where Month_ID in
		(
		select Distinct Month_ID from dbo.ipi_Calendar_lookup$
		where [Fiscal Year]= 'FY21'
		)
)

-- YoY from 20 and 21


select a.Total_Revenue21, b.Total_Revenue20, a.Total_Revenue21-b.Total_Revenue20 as Dollar_Diff_YoY, 
(a.Total_Revenue21/b.Total_Revenue20 -1)*100 as Perct_Diff_YoY
from
	(
	select SUM(Revenue) as Total_Revenue21 from dbo.['Revenue Data(Raw)$']
	where Month_ID in
		( 
		select Distinct Month_ID from dbo.ipi_Calendar_lookup$
		where [Fiscal Year]= 'FY21'
		)
	) as a,
	(
	select SUM(Revenue) as Total_Revenue20 from dbo.['Revenue Data(Raw)$']
	where Month_ID in
		( 
			select Distinct Month_ID - 12 from dbo.['Revenue Data(Raw)$'] 
			where Month_ID in
					(
					select Distinct Month_ID from dbo.ipi_Calendar_lookup$
					where [Fiscal Year]= 'FY21'
					)
		)
	)b


--3 What is the MoM Revenue Performance?
-- Check Revenue for latest moth

select Month_ID, SUM(Revenue) as Total_Revenue21 from dbo.['Revenue Data(Raw)$']
where Month_ID in
	( 
	138
	)
	Group by Month_ID

-- Automate selecting latest month ID
select SUM(Revenue) as Latest_Month_Revenue21 from dbo.['Revenue Data(Raw)$']
where Month_ID in
	( 
	Select MAX(Month_ID) from dbo.['Revenue Data(Raw)$']
	)


-- MoM Revenue

select a.Latest_Month_Revenue21, b.Previous_Month_Revenue21, a.Latest_Month_Revenue21-b.Previous_Month_Revenue21 as Dollar_Diff_MoM,
(a.Latest_Month_Revenue21/b.Previous_Month_Revenue21-1)*100 as Perct_Diff_MoM from
(
select SUM(Revenue) as Latest_Month_Revenue21 from dbo.['Revenue Data(Raw)$']
where Month_ID in
	( 
	Select MAX(Month_ID) from dbo.['Revenue Data(Raw)$']
	)
) as a,	
(
select  SUM(Revenue) as Previous_Month_Revenue21 from dbo.['Revenue Data(Raw)$']
where Month_ID in
	( 
	Select MAX(Month_ID)-1 from dbo.['Revenue Data(Raw)$']
	)
) as b


--4. What is the Total Revenue Vs Target performance for the Year?

-- Revenue FY21

select SUM(Revenue) as Total_Revenue from dbo.['Revenue Data(Raw)$']
where Month_ID in
( 
select Distinct Month_ID from dbo.ipi_Calendar_lookup$
where [Fiscal Year]= 'FY21'
)

-- To find Target
select Month_ID, sum(Target) as Target from dbo.['Targets Data(Raw)$']
where Month_ID in 
	(
	select Distinct Month_ID from dbo.ipi_Calendar_lookup$
	where [Fiscal Year]= 'FY21'
	)
--Group by Month_ID
--select where monthID exists
( 
	select Distinct Month_ID from dbo.['Revenue Data(Raw)$'] 
	where Month_ID in
		(
		select Distinct Month_ID from dbo.ipi_Calendar_lookup$
		where [Fiscal Year]= 'FY21'
		)
)


--Select Target only where MonthID present

select Month_ID, sum(Target) as Target from dbo.['Targets Data(Raw)$']
where Month_ID in 
	( 
	select Distinct Month_ID from dbo.['Revenue Data(Raw)$'] 
	where Month_ID in
		(
		select Distinct Month_ID from dbo.ipi_Calendar_lookup$
		where [Fiscal Year]= 'FY21'
		)
) Group by Month_ID


-- Solution to Question 4
select a.Total_Revenue, b.Target, a.Total_Revenue-b.Target as Dollar_Diff,
(a.Total_Revenue/b.Target-1)*100 as Perc_Dollar_Diff
from
(
	select SUM(Revenue) as Total_Revenue from dbo.['Revenue Data(Raw)$']
	where Month_ID in
	( 
	select Distinct Month_ID from dbo.ipi_Calendar_lookup$
	where [Fiscal Year]= 'FY21'
	)
) as a,
(
	select sum(Target) as Target from dbo.['Targets Data(Raw)$']
	where Month_ID in 
		( 
		select Distinct Month_ID from dbo.['Revenue Data(Raw)$'] 
		where Month_ID in
			(
			select Distinct Month_ID from dbo.ipi_Calendar_lookup$
			where [Fiscal Year]= 'FY21'
			)
	)
) as b


--5  What is the Revenue Vs Target performance Per Month?

select a.Month_ID, c.[Fiscal Month], a.Total_Revenue, b.Target, a.Total_Revenue-b.Target as Dollar_Diff,
(a.Total_Revenue/b.Target-1)*100 as Perc_Dollar_Diff
from
	(
		select Month_ID, SUM(Revenue) as Total_Revenue from dbo.['Revenue Data(Raw)$']
		where Month_ID in
		( 
		select Distinct Month_ID from dbo.ipi_Calendar_lookup$
		where [Fiscal Year]= 'FY21'
		) Group by Month_ID
	) as a

Left Join

	(
		select Month_ID, sum(Target) as Target from dbo.['Targets Data(Raw)$']
		where Month_ID in 
			( 
			select Distinct Month_ID from dbo.['Revenue Data(Raw)$'] 
			where Month_ID in
				(
				select Distinct Month_ID from dbo.ipi_Calendar_lookup$
				where [Fiscal Year]= 'FY21'
				)
		) Group by Month_ID
	) as b
On a.Month_ID = b.Month_ID

Left Join 

(
	select Distinct Month_ID,[Fiscal Month] from dbo.ipi_Calendar_lookup$
) as c

On  a.Month_ID = c.Month_ID

Order By a.Month_ID
