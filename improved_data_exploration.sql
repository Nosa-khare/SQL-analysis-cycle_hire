-- retrieve data FROM cycle stations table
SELECT
  *
FROM
  `hazel-tea-194609.technical_ex_data.cycle_stations`
LIMIT
  1000;

-- retrieve data from cycle hire table
SELECT
  *
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
LIMIT
  1000;


/*QUESTION 1: What time period does the dataset cover */


-- find the earliest start date from cycle hire (i.e first cycle checkout)
SELECT
  MIN(start_date) AS first_check_in
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`;

-- find the most recent end date from cycle (i.e last cycle check in)
SELECT
  MAX(end_date) AS last_check_out
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`;

-- to get the duration in years
SELECT
  DATE_DIFF(DATE (MAX(end_date)), DATE(MIN(start_date)), YEAR) AS period_in_years
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`;




/*QUESTION 2: What is the extent of the cycle network*/


SELECT
  latitude,
  longitude
FROM
  `hazel-tea-194609.technical_ex_data.cycle_stations`;
SELECT
  MAX(longitude) AS furthest_north
FROM
  `hazel-tea-194609.technical_ex_data.cycle_stations`;
SELECT
  MIN(longitude) AS furthest_south
FROM
  `hazel-tea-194609.technical_ex_data.cycle_stations`;
SELECT
  MAX(latitude) AS furthest_east
FROM
  `hazel-tea-194609.technical_ex_data.cycle_stations`;
SELECT
  MIN(latitude) AS furthest_west
FROM
  `hazel-tea-194609.technical_ex_data.cycle_stations`;




/*QUESTION 3: What hours of the day and days of the week does the cycle hire
 network experience the most number of cycle check outs*/


-- first get the start date hours
SELECT
  TIME(start_date)
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire` 
LIMIT 5;


-- extract the hour mark
SELECT
  EXTRACT(HOUR 
  FROM 
    (TIME(start_date))) AS hour_of_day 
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire` 
  LIMIT 5;


-- group by hour of day and its number of occurence
SELECT
  COUNT(EXTRACT(HOUR FROM (TIME(start_date)))) AS frequency,
  EXTRACT(HOUR FROM (TIME(start_date))) AS hour_of_day 
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY 
  hour_of_day;


-- get maximum frequency
SELECT
  MAX (frequency),
FROM (
  SELECT
    COUNT(EXTRACT(HOUR FROM (TIME(start_date)))) AS frequency,
    EXTRACT(HOUR FROM (TIME(start_date))) AS hour_of_day 
  FROM
    `hazel-tea-194609.technical_ex_data.cycle_hire`
  GROUP BY 
    hour_of_day);


-- get the hour of day with maximum frequency
SELECT 
  COUNT(EXTRACT(HOUR FROM (TIME(start_date)))) AS frequency,
  EXTRACT(HOUR FROM (TIME(start_date))) AS hour_of_day
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY
  hour_of_day
ORDER BY
  frequency DESC
LIMIT 1


-- day of week


-- convert to date
SELECT start_date, DATE(start_date) AS date
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`


--extract day of week from date
SELECT
  start_date,
  DATE(start_date) AS date,
  EXTRACT(DAYOFWEEK FROM DATE(start_date)) AS day
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
  

-- grouping day_of_week by frequency of occurence
SELECT
  COUNT(EXTRACT(DAYOFWEEK FROM DATE(start_date))) AS frequency,
  EXTRACT(DAYOFWEEK FROM DATE(start_date)) AS day_of_week  
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY day_of_week    


-- now, get the busiest day of the week and its total check-out frequency
SELECT 
  COUNT(EXTRACT(DAYOFWEEK FROM DATE(start_date))) AS frequency,
  EXTRACT(DAYOFWEEK FROM DATE(start_date)) AS day_of_week
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY
  day_of_week
ORDER BY
  frequency DESC
LIMIT 1




/*QUESTION 4: What are the shortest and longest journey durations made using the hire cycle network*/


-- get journey durations
SELECT
  rental_id,
  duration FROM `hazel-tea-194609.technical_ex_data.cycle_hire` 
LIMIT 10;


-- get shortest duration
SELECT
  MIN(duration)
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`

-- get longest duration
SELECT
  MAX(duration)
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`;


-- get trip with shortest duration
SELECT 
  rental_id,
  duration
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
ORDER BY
  duration ASC
LIMIT 1


-- get trip with longest duration
SELECT 
  rental_id,
  duration
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
ORDER BY
  duration DESC
LIMIT 1


/*QUESTION 6: What is the common cycle hire network route  --rephrased*/


-- get start and end station id's for each trip
SELECT
  start_station_id,
  end_station_id,
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
LIMIT 10


-- form a route code with the id's
SELECT
  start_station_id,
  end_station_id,
  CONCAT(start_station_id, "_to_", end_station_id) AS route_code
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
LIMIT 50


-- group by route_code to get the frequency of distinct routes
SELECT
  COUNT(CONCAT(start_station_id, "_to_", end_station_id)) AS frequency,
  CONCAT(start_station_id, "_to_", end_station_id) AS route_code
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY 
  route_code


-- for top 5 routes
SELECT 
  COUNT(CONCAT(start_station_id, "_to_", end_station_id)) AS frequency,
  CONCAT(start_station_id, "_to_", end_station_id) AS route_code
FROM
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY
  route_code
ORDER BY
  frequency DESC
LIMIT 5




/*QUESTION 7: At what hour of the day and at which stations is cycle check out the most in cycle hire network  --rephrased*/


-- get the hour extracted from start_date, and the start_station id's for each trip
SELECT
  EXTRACT(HOUR FROM start_date) AS hour_of_day,
  start_station_id
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
LIMIT 10


-- combine the hour_of_day and start_station_id columns to get the time_and_place column
SELECT
  EXTRACT(HOUR FROM start_date) AS hour_of_day,
  start_station_id,
  CONCAT(EXTRACT(HOUR FROM start_date), "__", start_station_id) AS time_and_place
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
LIMIT 10


-- group by where_and_when to get the frequency of distinct values
SELECT
  COUNT(CONCAT(EXTRACT(HOUR FROM start_date), "__", start_station_id)) AS frequency,
  CONCAT(EXTRACT(HOUR FROM start_date), "__", start_station_id) AS time_and_place
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY
  time_and_place


-- for top 10 time_and_place
SELECT
  COUNT(CONCAT(EXTRACT(HOUR FROM start_date), "__", start_station_id)) AS frequency,
  CONCAT(EXTRACT(HOUR FROM start_date), "__", start_station_id) AS time_and_place
FROM 
  `hazel-tea-194609.technical_ex_data.cycle_hire`
GROUP BY
  time_and_place
ORDER BY
  frequency DESC
LIMIT 10
