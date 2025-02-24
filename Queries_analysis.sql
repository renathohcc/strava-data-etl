SELECT 
    *
FROM
    activities
WHERE
    activity_type = 'Run';
    
-- Get total distance 
SELECT 
    SUM(distance) AS total_distance
FROM
    activities
WHERE
    activity_type = 'Run';

-- Get total distance per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    SUM(distance) AS total_distance
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- GET total distance per year
SELECT 
    DATE_FORMAT(start_date, '%Y') AS year,
    SUM(distance) AS total_distance
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y')
ORDER BY year;

-- GET average distance per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    avg(distance) AS avg_distance_month
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- Get the Max_Speed per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    MAX(max_speed) AS max_speed_month
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- Get the average speed per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    AVG(avg_speed) AS avg_speed_month
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- GET the total average speed
SELECT 
    AVG(avg_speed) AS avg_speed
FROM
    activities
WHERE
    activity_type = 'Run';

-- GET the total duration per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    SUM(duration / 60) AS total_duration
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- GET the average duration per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    AVG(duration) AS avg_duration
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- GET total duration time
SELECT 
    SUM(duration / 60) AS total_duration -- get the duration time in hours
FROM
    activities
WHERE
    activity_type = 'Run';

-- Get the pace for activity
SELECT 
    activity_name,
    distance,
    duration,
    (duration / distance) AS pace
FROM
    activities
WHERE
    activity_type = 'Run';

-- GET the average pace per month
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') AS month,
    AVG(duration / distance) AS avg_pace
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- GET the average pace total
SELECT 
    AVG(duration / distance) AS avg_pace
FROM
    activities
WHERE
    activity_type = 'Run';

use strava;

-- GET the relantionship between the Hour of the day, distance and pace
SELECT 
    HOUR(start_date) AS hour_of_day,
    AVG(distance) AS avg_distance,
    AVG(duration / distance) AS avg_pace
FROM
    activities
WHERE
    activity_type = 'Run'
GROUP BY HOUR(start_date)
ORDER BY hour_of_day;

-- GET a table with activies, distance, duration, hour, pace
SELECT 
    activity_name,
    distance,
    duration,
    start_date,
    (duration / distance) AS pace
FROM
    activities
WHERE
    activity_type = 'Run'
ORDER BY start_date ASC;

-- Get the pace monthly evolution
WITH monthly_pace AS (
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m') AS month,
        AVG(duration / distance) AS avg_pace
    FROM
        activities
    WHERE
        activity_type = 'Run'
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
),
pace_evolution AS (
    SELECT
        month,
        avg_pace,
        LAG(avg_pace) OVER (ORDER BY month) AS previous_month_pace,
        (avg_pace - LAG(avg_pace) OVER (ORDER BY month)) / LAG(avg_pace) OVER (ORDER BY month) * 100 AS pace_change_percentage
    FROM
        monthly_pace
)
SELECT
    month,
    avg_pace,
    previous_month_pace,
    pace_change_percentage
FROM
    pace_evolution
ORDER BY month;

-- GET distance monthly evolution
WITH monthly_distance AS (
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m') AS month,
        AVG(distance) AS avg_distance
    FROM
        activities
    WHERE
        activity_type = 'Run'
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
),
distance_evolution AS (
    SELECT
        month,
        avg_distance,
        LAG(avg_distance) OVER (ORDER BY month) AS previous_month_distance,
        (avg_distance - LAG(avg_distance) OVER (ORDER BY month)) / LAG(avg_distance) OVER (ORDER BY month) * 100 AS distance_change_percentage
    FROM
        monthly_distance
)
SELECT
    month,
    avg_distance,
    previous_month_distance,
    distance_change_percentage
FROM
    distance_evolution
ORDER BY month;

