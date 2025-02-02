# CASE STUDY ANALYSIS

## INTRODUCTION
In this case study, I analyze historical data from a Chicago-based bike-share company to identify trends in how their customers use bikes differently.

## SCENARIO
Cyclistic is a bike-share company based in Chicago with two types of customers. Customers who purchase single-ride or full-day passes are known as casual riders, while those who purchase annual memberships are known as members. Cyclistic’s financial analysts have concluded that annual members are much more profitable than casual riders. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships.

The marketing analytics team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, the team will design a new marketing strategy to convert casual riders into annual members. The primary stakeholders for this project include Cyclistic’s director of marketing and the Cyclistic executive team. The Cyclistic marketing analytics team are secondary stakeholders.

## DEFINING THE PROBLEM
The main problem for the director of marketing and marketing analytics team is this: design marketing strategies aimed at converting Cyclistic’s casual riders into annual members. There are three questions that will guide this future marketing program. For my scope on this project, I will analyze the first question:

1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

By looking at the data, we will be able to first get a broad sense of certain patterns that are occurring in the two different groups. Understanding the differences will provide more accurate customer profiles for each group. These insights will help the marketing analytics team design high-quality targeted marketing for converting casual riders into members. For the Cyclistic executive team, these insights will help Cyclistic maximize the number of annual members and will fuel future growth for the company.

## BUSINESS TASK
Analyze historical bike trip data to identify trends in how annual members and casual riders use Cyclistic bikes differently.

## DATA SOURCES
We’ll be using Cyclistic’s historical bike trip data from the last 12 months, which is publicly available [here](https://divvy-tripdata.s3.amazonaws.com/index.html). The data is made available by Motivate International Inc. under this [license](https://divvybikes.com/data-license-agreement). The data is stored in spreadsheets. There are 12 .CSV files total:

- 2022-02_divvy_trip-data.csv
- 2022-03_divvy_trip-data.csv
- 2022-04_divvy_trip-data.csv
- 2022-05_divvy_trip-data.csv
- 2022-06_divvy_trip-data.csv
- 2022-07_divvy_trip-data.csv
- 2022-08_divvy_trip-data.csv
- 2022-09_divvy_trip-data.csv
- 2022-10_divvy_trip-data.csv
- 2022-11_divvy_trip-data.csv
- 2022-12_divvy_trip-data.csv
- 2023-01_divvy_trip-data.csv

The data is structured in rows (records) and columns (fields). Each record represents one trip, and each trip has a unique field that identifies it: ride_id. Each trip is anonymized and includes the following fields:

- ride_id: Ride id - unique
- rideable_type: Bike type - Classic, Docked, Electric
- started_at: Trip start day and time
- ended_at: Trip end day and time
- start_station_name: Trip start station
- start_station_id: Trip start station id
- end_station_name: Trip end station
- end_station_id: Trip end station id
- start_lat: Trip start latitude
- start_lng: Trip start longitude
- end_lat: Trip end latitude
- end_lng: Trip end longitude
- member_casual: Rider type - Member or Casual

Bike station data that is made publicly available by the city of Chicago will also be used. It can be downloaded [here](https://data.cityofchicago.org/Transportation/Divvy-Bicycle-Stations/bbyy-e7gq/data). In terms of bias and credibility, both data sources we are using are ROCCC:

- **Reliable and original:** This is public data that contains accurate, complete, and unbiased info on Cyclistic’s historical bike trips. It can be used to explore how different customer types are using Cyclistic bikes.
- **Comprehensive and current:** These sources contain all the data needed to understand the different ways members and casual riders use Cyclistic bikes. The data is from the past 12 months. It is current and relevant to the task at hand. This is important because the usefulness of data decreases as time passes.
- **Cited:** These sources are publicly available data provided by Cyclistic and the City of Chicago. Governmental agency data and vetted public data are typically good sources of data.

## DATA CLEANING AND MANIPULATION

### MICROSOFT EXCEL: INITIAL DATA CLEANING AND MANIPULATION
Our next step is making sure the data is stored appropriately and prepared for analysis. After downloading all 12 zip files and unzipping them, I housed the files in a temporary folder on my desktop. I also created subfolders for the .CSV files and the .XLS files so that I have a copy of the original data. Then, I launched Excel, opened each file, and chose to Save As an Excel Workbook file. For each .XLS file, I did the following:

- Changed the format of started_at and ended_at columns
  - Formatted as custom DATETIME: Format > Cells > Custom > yyyy-mm-dd h:mm:ss
- Created a column called ride_length: Calculated the length of each ride by subtracting the column started_at from the column ended_at (example: =D2-C2)
  - Formatted as TIME: Format > Cells > Time > HH:MM:SS (37:30:55)
- Created a column called ride_date: Calculated the date of each ride started using the DATE command (example: =DATE(YEAR(C2),MONTH(C2),DAY(C2)))
  - Formatted as Date: Format > Cells > Date > YYYY-MM-DD
- Created a column called ride_month: Entered the month of each ride and formatted as number (example: January: =1) Format > Cells > Number
- Created a column called ride_year: Entered the year of each ride and formatted as general Format > Cells > General > YYYY
- Created a column called start_time: Calculated the start time of each ride using the started_at column Formatted as TIME Format > Cells > Time > HH:MM:SS (37:30:55)
- Created a column called end_time: Calculated the end time of each ride using the ended_at column Formatted as TIME Format > Cells > Time > HH:MM:SS (37:30:55)
- Created a column called day_of_week: Calculated the day of the week that each ride started using the WEEKDAY command (example: =WEEKDAY(C2,1)) Formatted as a NUMBER with no decimals Format > Cells > Number (no decimals) > 1,2,3,4,5,6,7

Note: 1 = Sunday and 7 = Saturday. After making these updates, I saved each .XLS file as a new .CSV file.

### BIGQUERY: FURTHER DATA CLEANING AND MANIPULATION VIA SQL
Since these datasets are so large, it makes sense to move our analysis to a tool that is better suited for handling large datasets. I chose to use SQL via BigQuery. In order to continue processing the data in BigQuery, I created a bucket in Google Cloud Storage to upload all 12 files. I then created a project in BigQuery and uploaded these files as datasets. I’ve provided my initial cleaning and transformation SQL queries here for reference: `initial_setup_query.sql`.

#### CREATE QUARTERLY TABLES
In order to perform analysis by season, let’s combine these tables. We’ll create Q1, Q2, Q3, and Q4 tables for analysis. We’ll have two Q1 tables–one for 2022 and one for 2023–since we have FEB/MAR data from 2022 and JAN data from 2023:

- Table 1: 2022_Q1 -> FEB(02), MAR(03)
- Table 2: 2022_Q2 -> APR(04), MAY(05), JUN(06)
- Table 3: 2022_Q3 -> JUL(07), AUG(08), SEP(09)
- Table 4: 2022_Q4 -> OCT(10), NOV(11), DEC(12)
- Table 5: 2023_Q1 -> JAN(01)

We’ll first create 2022_Q2 and then repeat for the remaining four tables:

```sql
-- Using UNION to join 2022_Q2 tables: APR, MAY, JUN
SELECT 
    ride_id, 
    rideable_type, 
    started_at, 
    ended_at, 
    ride_length, 
    ride_date,
    ride_month,
    ride_year,
    start_time,
    end_time,
    day_of_week,
    start_station_name, 
    start_station_id, 
    end_station_name, 
    end_station_id, 
    start_lat, 
    start_lng, 
    end_lat, 
    end_lng, 
    member_casual,
    'Q2' AS quarter
FROM 
    `divvy-tripdata-426901.2022_04_divvy_tripdata.2022_04_divvy_tripdata`
UNION DISTINCT

  
SELECT 
    ride_id, 
    rideable_type, 
    started_at, 
    ended_at, 
    ride_length, 
    ride_date,
    ride_month,
    ride_year,
    start_time,
    end_time,
    day_of_week,
    start_station_name, 
    start_station_id, 
    end_station_name, 
    end_station_id, 
    start_lat, 
    start_lng, 
    end_lat, 
    end_lng, 
    member_casual,
    'Q2' AS quarter
FROM 
    `divvy-tripdata-426901.2022_05_divvy_tripdata.2022_05_divvy_tripdata`
UNION DISTINCT  
SELECT 
    ride_id, 
    rideable_type, 
    started_at, 
    ended_at, 
    ride_length, 
    ride_date,
    ride_month,
    ride_year,
    start_time,
    end_time,
    day_of_week,
    start_station_name, 
    start_station_id, 
    end_station_name, 
    end_station_id, 
    start_lat, 
    start_lng, 
    end_lat, 
    end_lng, 
    member_casual,
    'Q2' AS quarter
FROM 
    `divvy-tripdata-426901.2022_06_divvy_tripdata.2022_06_divvy_tripdata`
```

#### AGGREGATE QUARTERLY TABLES INTO A YEARLY TABLE
```sql
-- Creating 2022_yearly table by combining all four quarters
CREATE OR REPLACE TABLE `divvy-tripdata-426901.2022_yearly` AS
SELECT * FROM `divvy-tripdata-426901.2022_Q1`
UNION DISTINCT
SELECT * FROM `divvy-tripdata-426901.2022_Q2`
UNION DISTINCT
SELECT * FROM `divvy-tripdata-426901.2022_Q3`
UNION DISTINCT
SELECT * FROM `divvy-tripdata-426901.2022_Q4`
```

## ANALYSIS

### RIDER TYPE PERCENTAGES BY SEASON
```sql
-- Calculating rider type percentages by season
SELECT 
    quarter,
    member_casual,
    COUNT(ride_id) AS total_rides,
    ROUND((COUNT(ride_id) / SUM(COUNT(ride_id)) OVER (PARTITION BY quarter))*100, 2) AS percentage
FROM 
    `divvy-tripdata-426901.2022_yearly`
GROUP BY 
    quarter, member_casual
ORDER BY 
    quarter, member_casual;
```

### AVERAGE RIDE LENGTH BY SEASON AND RIDER TYPE
```sql
-- Calculating average ride length by season and rider type
SELECT 
    quarter,
    member_casual,
    ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, SECOND))/60, 2) AS avg_ride_length_min
FROM 
    `divvy-tripdata-426901.2022_yearly`
GROUP BY 
    quarter, member_casual
ORDER BY 
    quarter, member_casual;
```

### MOST POPULAR START STATIONS BY RIDER TYPE
```sql
-- Determining the most popular start stations by rider type
SELECT 
    start_station_name,
    member_casual,
    COUNT(ride_id) AS total_rides
FROM 
    `divvy-tripdata-426901.2022_yearly`
WHERE 
    start_station_name IS NOT NULL
GROUP BY 
    start_station_name, member_casual
ORDER BY 
    total_rides DESC
LIMIT 10;
```
Instead of detailing each quarter individually, refer to the SQL files for detailed quarterly analysis:

- [Analysis 2022 Q1](https://github.com/Sirlarry5/CYCLIST-CASE-STUDY-/blob/69b5f74ac334f4e53ff503984339d82d5fd3fae8/2022_Q1_Analysis.sql)
- [Analysis 2022 Q2](https://github.com/Sirlarry5/CYCLIST-CASE-STUDY-/blob/69b5f74ac334f4e53ff503984339d82d5fd3fae8/2022_Q2_Analysis.sql)
- [Analysis 2022 Q3](https://github.com/Sirlarry5/CYCLIST-CASE-STUDY-/blob/69b5f74ac334f4e53ff503984339d82d5fd3fae8/2022_Q3_Analysis.sql)
- [Analysis 2022 Q4](https://github.com/Sirlarry5/CYCLIST-CASE-STUDY-/blob/69b5f74ac334f4e53ff503984339d82d5fd3fae8/2022_Q4_Analysis.sql)
- [Analysis 2023 Q1](https://github.com/Sirlarry5/CYCLIST-CASE-STUDY-/blob/69b5f74ac334f4e53ff503984339d82d5fd3fae8/2023_Q1_Analysis.sql)

### Summary of Quarterly Analysis

High-level insights and trends from each quarter are summarized in the project documentation.

## Full Year Analysis

To analyze all twelve months together, we combined quarterly tables into one comprehensive table using SQL. Refer to the SQL file for the full year analysis:

- [Analysis Full Year](https://github.com/Sirlarry5/CYCLIST-CASE-STUDY-/blob/4a23d4b7862f4054409a25e34ecc02049e4f8432/Full%20year%20Analysis.sql)

### Summary and Visualizations

For a comprehensive summary and visualization of the full year analysis, i will be using Power Bi please explore the following resources:

- [Power BI Dashboard](https://drive.google.com/file/d/1YXHJL6dmUm50fy8g34CLSCOoEXR4qhBQ/view?usp=drive_link)
- [PDF Power Bi Dashboard View](https://acrobat.adobe.com/id/urn:aaid:sc:EU:d5150238-5469-49a6-be5f-c0cafc2609e3)
- [Presentation Slides(The Moment Of Truth Converting Casual Riders to Members)](https://docs.google.com/presentation/d/1QSIPCY1Obu1wVnDLUN3X2pfkPpDealo62ut_N8xhj8s/edit?usp=sharing)

