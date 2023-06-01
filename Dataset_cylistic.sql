select* from cyclistic.dataset;

USE cyclistic;

#RPD(Ride Per Day) DATA
Create table Rides_per_day_casual (
started_at_date DATE,
Rides_per_day_C INT);
INSERT INTO Rides_per_day_casual (started_at_date, rides_per_day_C)
SELECT started_at_date, COUNT(*) AS Rides_per_day_C
FROM dataset
WHERE member_casual = 'casual'
GROUP BY started_at_date;

Create table Rides_per_day_member (
started_at_date DATE,
Rides_per_day_M INT);
INSERT INTO Rides_per_day_member (started_at_date, rides_per_day_M)
SELECT started_at_date, COUNT(*) AS Rides_per_day_M
FROM dataset
WHERE member_casual = 'member'
GROUP BY started_at_date;

CREATE TABLE Rides_per_day_total AS
SELECT started_at_date AS Started_at_date, COUNT(*) AS Rides_per_day_total
FROM dataset
GROUP BY started_at_date;

SELECT * FROM rides_per_day_casual
SELECT * from Rides_per_day_member
SELECT* from Rides_per_day_total

Create table Rpd_Data as
SELECT rpd_c.started_at_date, rpd_c.rides_per_day_c, rpd_m.rides_per_day_m, rpd_t.rides_per_day_total
FROM Rides_per_day_casual as rpd_c
left join rides_per_day_member as rpd_m on rpd_c.started_at_date=rpd_m.started_at_date
left join rides_per_day_total as rpd_t
on rpd_c.started_at_date=rpd_t.started_at_date

Select * FROM RPD_DATA

#DPD(Duration Per Day)_DATA
Create table Dur_per_day_C (
started_at_date DATE,
Dur_per_day_C INT);
INSERT INTO Dur_per_day_C ( Started_at_Date, Dur_Per_day_C)
SELECT started_at_date, SUM(TIMESTAMPDIFF(MINUTE, 
CONCAT(started_at_date, ' ', started_at_time), 
CONCAT(ended_at_date, ' ', ended_at_time))) AS Dur_per_day_C
FROM dataset
WHERE member_casual = 'casual'
GROUP BY started_at_date;

Create table Dur_per_day_M (
started_at_date DATE,
Dur_per_day_M INT);
INSERT INTO Dur_per_day_M ( Started_at_Date, Dur_Per_day_M)
SELECT started_at_date, SUM(TIMESTAMPDIFF(MINUTE, 
CONCAT(started_at_date, ' ', started_at_time), 
CONCAT(ended_at_date, ' ', ended_at_time))) AS Dur_per_day_M
FROM dataset
WHERE member_casual = 'member'
GROUP BY started_at_date;

Create table Dur_per_day_total as 
SELECT DATE(started_at_date) AS started_at_date,
SUM(TIMESTAMPDIFF(MINUTE,CONCAT(started_at_date, ' ', started_at_time),
CONCAT(ended_at_date, ' ', ended_at_time))) AS total_duration_per_day
FROM Dataset
GROUP BY DATE(started_at_date);

Select * from Dur_per_day_C
Select * from Dur_per_day_M
Select* from Dur_per_day_total

Create table Dpd_Data as
SELECT dpd_c.started_at_date, dpd_c.dur_per_day_c, dpd_m.dur_per_day_m, dpd_t.total_duration_per_day
FROM Dur_per_day_C as dpd_c
left join Dur_per_day_m as dpd_m on dpd_c.started_at_date=dpd_m.started_at_date
left join dur_per_day_total as dpd_t
on dpd_c.started_at_date=dpd_t.started_at_date

Select * from dpd_data

#CBP(Customer Bike Preference)_DATA
Create Table BRP_Data as
SELECT member_casual, rideable_type, COUNT(*) AS ride_count,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM dataset) * 100), 2) AS ride_percentage
FROM dataset
GROUP BY member_casual, rideable_type;

Create Table BRD_Data as
SELECT member_casual,rideable_type, SUM(TIMESTAMPDIFF(MINUTE, 
CONCAT(started_at_date, ' ', started_at_time), 
CONCAT(ended_at_date, ' ', ended_at_time))) AS total_duration_minutes
FROM dataset
GROUP BY member_casual,rideable_type;

Select * from BRP_Data
Select * from BRD_Data

Create table CBP_Data as
SELECT BRP_D.member_casual, BRP_D.Rideable_type, BRP_D.Ride_count, BRP_D. Ride_percentage,
BRD_D.Total_duration_minutes
FROM BRP_Data as BRP_D
left join BRD_Data as BRD_D on (BRP_D.rideable_type=BRD_D.rideable_type and BRP_D.member_casual=BRD_D.member_casual)

Select* from CBP_Data

#SR(STATION RIDE) DATA 
Create Table SR_C as
SELECT start_station_name, COUNT(*) AS total_rides_C
FROM dataset
WHERE member_casual = 'casual'
GROUP BY start_station_name;

Create Table SR_M as
SELECT start_station_name, COUNT(*) AS total_rides_M
FROM dataset
WHERE member_casual = 'member'
GROUP BY start_station_name;

Create Table SR_T as
SELECT start_station_name, COUNT(*) AS total_rides_T
FROM dataset
GROUP BY start_station_name;

Select * from SR_C
Select * from SR_M
Select * From SR_T 

Create Table SR_Data as
Select SR_C. Start_Station_Name, SR_C. Total_Rides_c, SR_M.Total_Rides_m, SR_T.Total_Rides_t
FROM SR_C 
Left Join SR_M on SR_C.Start_Station_name=SR_M.Start_Station_Name
Left Join SR_T on SR_C.Start_Station_name=SR_T.Start_Station_Name
 
Select * from SR_DATA

#TRIP DURATION FROM START TO END
Create Table TD_Data as
SELECT start_station_name, end_station_name, 
SUM(TIMESTAMPDIFF(MINUTE, CONCAT(started_at_date, ' ', started_at_time), 
CONCAT(ended_at_date, ' ', ended_at_time))) AS total_duration_minutes
FROM dataset
GROUP BY start_station_name, end_station_name;

Select * from TD_Data





