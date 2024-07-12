/*
Cyclistic Case Study: Quarterly Data Exploration, 2022_Q4
Windows Functions, Aggregate Functions, Converting Data Types
*/

-- Select columns from Q4 data to preview

SELECT  
        ride_id,
        started_at,
        ended_at,
        ride_length,
        day_of_week, 
        start_station_name,
        end_station_name,
        member_casual
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
ORDER BY 
        ride_id DESC
        -- ride_length DESC


-- Total Trips: Members vs Casual 
-- Looking at overall, annual member and casual rider totals

SELECT 
        TotalTrips,
        TotalMemberTrips,
        TotalCasualTrips,
        ROUND(TotalMemberTrips / TotalTrips, 2) * 100 AS MemberPercentage,
        ROUND(TotalCasualTrips / TotalTrips, 2) * 100 AS CasualPercentage
FROM 
        (
        SELECT
                COUNT(ride_id) AS TotalTrips,
                COUNTIF(member_casual = 'member') AS TotalMemberTrips,
                COUNTIF(member_casual = 'casual') AS TotalCasualTrips
        FROM
                `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
        )


-- Average Ride Lengths: Members vs Casual  
-- Looking at overall, member and casual average ride lengths

SELECT
        (
        SELECT 
                AVG(ride_length)
        FROM 
                `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
        ) AS AvgRideLength_Overall,
        (
        SELECT 
                AVG(ride_length) 
        FROM 
                `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
        WHERE 
                member_casual = 'member'
        ) AS AvgRideLength_Member,
        (
        SELECT 
                AVG(ride_length) 
        FROM 
                `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
        WHERE 
                member_casual = 'casual'
        ) AS AvgRideLength_Casual


-- Max Ride Lengths: Members vs Casual  
-- Looking at max ride lengths to check for outliers

SELECT
        member_casual,
        MAX(ride_length) AS ride_length_MAX
FROM
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        member_casual
ORDER BY
        ride_length_MAX DESC


-- Median Ride Lengths: Members vs Casual 
-- Looking at median because of outliers influence on AVG

SELECT
        member_casual,
        PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY ride_length) AS median_ride_length
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        member_casual
ORDER BY 
        median_ride_length DESC 
LIMIT 2


-- Rides per day: member and casual
-- Looking at which days have the highest number of rides

SELECT
        member_casual, 
        day_of_week AS mode_day_of_week -- Top number of day_of_week
FROM 
        (
        SELECT
                member_casual,
                day_of_week,
                ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_id) DESC) AS rn
        FROM
                `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
        GROUP BY
                member_casual,
                day_of_week
        )
WHERE
        rn = 1
ORDER BY
        member_casual DESC
LIMIT 2


-- Looking at average ride length per day of week

SELECT 
        day_of_week,
        AVG(ride_length) AS average_ride_length
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        day_of_week
ORDER BY
        average_ride_length DESC 
LIMIT 7


-- How about the median ride length per day of week?

SELECT
        day_of_week,
        PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY ride_length) AS median_ride_length
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        day_of_week
ORDER BY
        median_ride_length DESC 
LIMIT 7


-- Looking at AVG ride length per day of week for casual and annual

SELECT 
        member_casual,
        day_of_week,
        AVG(ride_length) AS average_ride_length
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        day_of_week,
        member_casual
ORDER BY
        average_ride_length DESC 
LIMIT 14


-- Looking at median ride lengths per day

SELECT
        member_casual,
        day_of_week,
        PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY ride_length) AS median_ride_length
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        day_of_week,
        member_casual
ORDER BY
        median_ride_length DESC 
LIMIT 7


-- Overall trips per day
-- Looking at total number of trips per day_of_week

SELECT  
        day_of_week,
        COUNT(DISTINCT ride_id) AS TotalTrips
FROM
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY 
        day_of_week
ORDER BY 
        TotalTrips DESC 
LIMIT 7


-- Overall, member, casual
-- Looking at total number of trips per day 

SELECT  
        day_of_week,
        COUNT(DISTINCT ride_id) AS TotalTrips,
        SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS MemberTrips,
        SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS CasualTrips
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY 
        day_of_week
ORDER BY 
        TotalTrips DESC 
LIMIT 7


-- Overall: member and casual
-- Looking at total number of trips per day 

SELECT
        day_of_week,
        member_casual,
        COUNT(DISTINCT ride_id) AS TotalTrips
FROM
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY
        day_of_week,
        member_casual
ORDER BY
        TotalTrips DESC
LIMIT 7


-- Start stations: member vs casual
-- Looking at start station counts

SELECT 
        start_station_name,
        COUNT(ride_id) AS total,
        SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
        SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM 
        `divvy-tripdata-426901.2022_Tripdata_Q4.2022_Tripdata_Q4`
GROUP BY 
        start_station_name
ORDER BY 
        total DESC
        -- member DESC
        -- casual DESC
