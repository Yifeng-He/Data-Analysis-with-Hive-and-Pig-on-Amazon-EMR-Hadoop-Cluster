
-- This Hive script is ued to analyze the movie data with the following row format: 
-- (id, movie_name, year, rating, length)
-- for example: 34,The Nightmare Before Christmas,1993,3.9,4568

-- create table to store the data from a csv file located in Amazon s3
CREATE EXTERNAL TABLE IF NOT EXISTS raw_data (id INT, movie_name STRING, year INT, rating DOUBLE, length DOUBLE) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LOCATION 's3://yifengsparkdata/';

-- create table to store the data after filtering out the rows with missing values
CREATE TABLE filtered_data (id INT, movie_name STRING, year INT, rating DOUBLE, length DOUBLE);

-- insert filtered data into the table 
INSERT OVERWRITE TABLE filtered_data 
SELECT id, movie_name, year, rating, length FROM raw_data WHERE rating is not NULL OR rating <> '' OR length(rating) > 0;


-- *** Task 1: find the top-rating movie for each year ordered on year (ascending)
-- output table format: year, movie_id, move_name, rating

-- create table to store the data the task 
CREATE TABLE task1_1 (year INT, id INT, movie_name STRING, rating DOUBLE);

-- insert data into table 
INSERT OVERWRITE TABLE task1_1 
SELECT year, id, movie_name, rating FROM filtered_data;

-- create table to store max rating for each year
CREATE TABLE task1_2 (year INT, maxRating DOUBLE);

-- insert data into table task1_2 and group on year 
INSERT OVERWRITE TABLE task1_2 
SELECT year, MAX(rating) FROM task1_1 GROUP BY year;

-- create table to store the output result
CREATE TABLE task1_3 (year INT, id INT, movie_name STRING, maxRating DOUBLE) 
 row format delimited fields terminated by ',' 
 lines terminated by '\n' 
 STORED AS TEXTFILE
 LOCATION 's3://yifengsparkoutput/hive_task1/';

-- insert data
INSERT OVERWRITE TABLE task1_3 
SELECT t2.year, t1.id, t1.movie_name, t2.maxRating FROM task1_1 t1 JOIN task1_2 t2 ON t1.year = t2.year AND 
  t1.rating = t2.maxRating ORDER BY t2.year;


-- *** Task 2: find the top-10 movies since 2005 ordered on rating (descending)
-- output result: id, movie_name, year, rating

-- create table to store the result for this task 
CREATE TABLE task2_1 (year INT, id INT, movie_name STRING, rating DOUBLE)
 row format delimited fields terminated by ',' 
 lines terminated by '\n' 
 STORED AS TEXTFILE
 LOCATION 's3://yifengsparkoutput/hive_task2/';

-- insert data 
INSERT OVERWRITE TABLE task2_1 
SELECT year, id, movie_name, rating from filtered_data WHERE year > 2004 ORDER BY rating DESC LIMIT 10;


-- *** Task 3: find the histogram of movie ratings
-- output result: rating_range (five bins), number_of_movies

-- create table to store the data for this task
CREATE TABLE task3_1 (rating_bin INT, id INT);

-- insert data
INSERT OVERWRITE TABLE task3_1 
SELECT cast(rating as INT), id from filtered_data;

-- create table to store the output result
CREATE TABLE task3_2 (rating_bin INT, number_movies INT)
 row format delimited fields terminated by ',' 
 lines terminated by '\n' 
 STORED AS TEXTFILE
 LOCATION 's3://yifengsparkoutput/hive_task3/';

-- insert data
INSERT OVERWRITE TABLE task3_2 
SELECT rating_bin, COUNT(id) from task3_1 GROUP BY rating_bin;

-- drop tables after all tasks are done
DROP TABLE IF EXISTS raw_data, filtered_data, task1_1, task1_2, task1_3, task2_1, task3_1, task3_2;
