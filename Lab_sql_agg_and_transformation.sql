USE sakila;

-- i.e test if the databases works
SELECT * FROM store; 

/*
CHALLENGE 1
*/

/* 1.- As a movie rental company, we need to use SQL built-in functions to help us gain 
insights into our business operations:
1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
1.2. Express the average movie duration in hours and minutes. 
Don't use decimals. 
Hint: look for floor and round functions.
*/

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.

SELECT * FROM sakila.film
ORDER BY length ASC;

SELECT MAX(length) AS max_duration, MIN(length) AS min_duration 
FROM sakila.film
ORDER BY title, length;

-- 1.2 Express the average movie duration in hours and minutes. Don't use decimals. 
-- Hint: look for floor and round functions.

SELECT length as "duration" 
FROM sakila.film;

-- Round 
SELECT FLOOR(115.27) AS FloorValue;

-- average movie duration in hours and minutes
SELECT 
SEC_TO_TIME((round(AVG(length),2))*60) 
as "average_duration" 
FROM sakila.film;


/* 2.- We need to use SQL to help us gain insights into our business operations related to rental dates:

2.1 Calculate the number of days that the company has been operating. 
Hint: To do this, use the rental table, and the DATEDIFF() function to subtract 
the earliest date in the rental_date column from the latest date.

2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. 
Return 20 rows of results.

2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', 
depending on the day of the week. 
Hint: use a conditional expression.
*/

-- 2.1 Calculate the number of days that the company has been operating. 
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.

SELECT*FROM sakila.rental
ORDER BY rental_date ASC;

SELECT
DATEDIFF((MAX(rental_date)), (MIN(rental_date))) AS number_of_Days_operating
FROM sakila.rental;


-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT*FROM sakila.rental;

SELECT rental_date,
MONTH(rental_date) AS month,
DAY(rental_date) AS weekday
FROM sakila.rental
LIMIT 20;

-- 2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', Hint: use a conditional expression.

SELECT*FROM sakila.rental;

SELECT rental_date, DAYOFWEEK(rental_date) as DAY_TYPE
FROM sakila.rental;

-- Final -- 
SELECT rental_date, 
    CASE 
        WHEN DAYOFWEEK(rental_date) IN (1,7) THEN 'Weekend' ELSE 'Workday'
    END AS 'day_type'
FROM sakila.rental;

/*The WEEKDAY() function returns the weekday number for a given date. 
     Note: 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 
     4 = Friday, 5 = Saturday, 6 = Sunday.*/
     
/* BETS help:
When writing the CASE WHEN statement, 
you need to write the whole condition:
CASE WHEN DAYOFWEEK(rental_date) = 1 THEN 'Weekend'...
Also, you don't need to write a condition for each weekday! 
You can write CASE WHEN DAYOFWEEK(rental_date) IN (1,7) THEN 'Weekend' ELSE 'Workday'
*/

/* 3.- We need to ensure that our customers can easily access information about our movie collection. 
To achieve this, 
- retrieve the film titles and their rental duration. 
If any rental duration value is NULL, replace it with the string 'Not Available'. 
- Sort the results by the film title in ascending order. 
Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
*/

SELECT title, rental_duration
FROM sakila.film
ORDER by rental_duration ASC,
CASE
WHEN rental_duration = ' ' THEN 'Not Available'
END;

/* 4.- As a marketing team for a movie rental company, we need to create a personalized email campaign for our customers. 
To achieve this, 
we want to retrieve the concatenated first and last names of our customers, 
along with the first 3 characters of their email address, 
so that we can address them by their first name and use their email address to send personalized recommendations. 
The results should be ordered by last name in ascending order to make it easier for us to use the data.
*/
SELECT*FROM sakila.customer;

SELECT first_name, last_name, email,
concat(first_name,last_name,left(email,3)) AS 'email_campaign' 
FROM sakila.customer
ORDER by last_name ASC;

/*
CHALLENGE 2
*/

/* 1.- We need to analyze the films in our collection to gain insights into our business operations. 
Using the film table, determine:
1.1 The total number of films that have been released.
1.2 The number of films for each rating.
1.3 The number of films for each rating, and sort the results in descending order of the number of films. 
This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.
*/

SELECT*FROM sakila.film;

-- 1.1 The total number of films that have been released.
SELECT
count(title) as films_released
FROM sakila.film;

-- 1.2 The number of films for each rating.
SELECT rating,
count(title) as films_for_rating
FROM sakila.film
GROUP BY rating;

-- 1.3 The number of films for each rating, and sort the results in descending order of the number of films. 
-- This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.

SELECT rating,
count(title) as films_for_rating
FROM sakila.film
GROUP BY rating
ORDER BY films_for_rating;

/* 2.- We need to track the performance of our employees. 
Using the rental table, determine the number of rentals processed by each employee. 
This will help us identify our top-performing employees and areas where additional training may be necessary.
*/
SELECT*FROM sakila.rental;

SELECT staff_id as employee,
count(rental_id) as rentals_processed
FROM sakila.rental
GROUP BY staff_id
ORDER by rentals_processed;

/* 3.- Using the film table, determine:
3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
Round off the average lengths to two decimal places. 
This will help us identify popular movie lengths for each category.
3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.
*/

SELECT*FROM sakila.film;

-- 3.1 The mean film duration for each rating, 
-- and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. 
-- This will help us identify popular movie lengths for each category.

SELECT rating, round(AVG(length),2) AS film_duration 
FROM sakila.film
GROUP BY rating
ORDER BY film_duration;

-- 3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.

SELECT rating, (SEC_TO_TIME((round(AVG(length),2))*60)) AS film_duration
FROM sakila.film
GROUP BY rating
HAVING film_duration > '02:00:00'
ORDER BY film_duration;

-- Other way:

SELECT rating, ROUND(AVG(length),2) AS mean_film_duration
FROM film
GROUP BY rating
HAVING ROUND(AVG(length),2)> 120
ORDER BY mean_film_duration DESC;

/* 4.- Determine which last names are not repeated in the table actor*/

SELECT DISTINCT last_name FROM sakila.actor;


