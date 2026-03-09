select * from [Trip Details]
select * from [Location ]

---------------------------------- KPI's -------------------------------->

--1. Total Bookings – How many trips were booked over a given period?
select
Count(*) as Total_Bookings
from [Trip Details]; --- ANS --->  1,03,728 .

--2. Total Booking Value – What is the total revenue generated from all bookings?
select 
sum(fare_amount) as Total_Booking_Value
from [Trip Details]; --- ANS ---> Rs. 1.34 Millions .

--3. Average Booking Value – What is the average revenue per booking?
select 
AVG(fare_amount) as AVG_Booking_Value
from [Trip Details]; --- ANS ---> Rs. 12.99  .

--4.Total Trip Distance – What is the total distance covered by all trips?
select 
sum(trip_distance) as Total_Trip_Distance
from [Trip Details]; --- ANS ---> 348K KM .

--5.Average Trip Distance – How far are customers traveling on average per trip?
select 
AVG(trip_distance) as AVG_Trip_Distance
from [Trip Details]; --- ANS ---> 3.36KM .

--6. Average Trip Time – What is the average duration of trips?
select 
AVG(DATEDIFF(MINUTE, Pickup_Time, Drop_Off_Time)) as AVG_Trip_Minutes
from [Trip Details]; --- ANS ---> 15 Minutes .

select 
avg(DATEDIFF(HOUR,Pickup_Time, Drop_Off_Time)) as AVG_Trip_Hours
from [Trip Details]; --- ANS ---> 0 Hours .



-------------------------------------------- Location Analysis -------------------------------------------
--1. Most Frequent Pickup Point ?
select top 10 l.Location,l.City, count(*) as Pickup_count
from [Trip Details] as td
join [Location ] as l
on td.PULocationID =l.LocationID
group by l.Location,l.City
order by Pickup_count desc;


--2. Most Frequent Drop Off Point ?
select top 10 l.Location,l.City, count(*) as DropOff_count
from [Trip Details] as td
join [Location ] as l
on td.DOLocationID =l.LocationID
group by l.Location,l.City
order by DropOff_count desc;

--3. Farthest Trip ? 
select concat(max(trip_distance),'KM') as Trip_Distance
from [Trip Details] --- ANS ---> 144.1KM .

--4. Total Bookings by Location (Top 5) ?
select top 5 l.Location,SUM(fare_amount) as Total_fare_amount 
from [Trip Details] as td
join [Location ] as l
on td.DOLocationID =l.LocationID
group by l.Location
order by Total_fare_amount desc;

--5. Most Preferred Vehicle for Location Pickup ?
select Vehicle , count(*) as total_booking
from [Trip Details]
group by Vehicle
order by total_booking desc;


--6. Top 3 PickUp Location by each Vehicle ?
select Vehicle , Location, total_booking, ranked from
	(select
		td.Vehicle , l.Location, count(*) as total_booking,
		DENSE_RANK() over(partition by td.Vehicle order by count(*) desc) as ranked
	from [Trip Details] as td
	join [Location ] as l
	on td.PULocationID = l.LocationID
	group by td.Vehicle, l.Location) t
where ranked <=3


-------------------------------------- Time Analysis ------------------------
--1. Booking trends across Monday to Sunday?
select DATENAME(WEEKDAY,Pickup_Time) as week_name, count(*) as total_bookings ,
DENSE_RANK() over( order by count(*) desc) as ranks
from [Trip Details]
group by DATENAME(WEEKDAY,Pickup_Time);

--2. By Hour and Time Total Booking ?
select
DATEPART(HOUR,Pickup_Time) as hours_of_day,
count(*) as Total_Bookings
from [Trip Details]
group by DATEPART(HOUR,Pickup_Time)
order by hours_of_day asc;











