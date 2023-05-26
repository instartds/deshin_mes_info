--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
/*
insert into BCM430T(CAL_DATE)
select top 7671 convert(nvarchar,DATEADD(d,ROW_NUMBER() over(order by object_id)-1 , '20000101'),112)  dt
from sys.all_objects

update BCM430T set dt = convert(DATEtime, cal_date,112)

*/
DECLARE @julian DATEtime

SET @julian = convert(DATEtime, '18991231', 112)
--SET @julian = convert(DATE, '20100101', 112)

update unilite.BCM430T  set nyear = year(dt)
	,nmonth= datepart(month, dt) 
	,nday = datepart(day, dt) 
	,doy = datepart(dayofyear, dt) 
	,woy = datepart(week, dt) 
	,dow = datepart(weekday, dt) 
	,julian= DATEDIFF(day, @julian, dt  )   

	/* 
SELECT c.*
	,year(c.dt) nyear
	,datepart(month, c.dt) nmonth
	,datepart(day, c.dt) nday
	,datepart(dayofyear, c.dt) doy
	,datepart(week, c.dt) woy
	,datepart(weekday, c.dt) dow
	,DATEDIFF(day, @julian, c.dt  )   julian
FROM BCM430T c
*/