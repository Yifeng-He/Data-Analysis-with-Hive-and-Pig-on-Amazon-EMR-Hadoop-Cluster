/* 
This pig script is ued to analyze the movie data with the following row format: (id, movie_name, year, rating, length), for example:
1,The Nightmare Before Christmas,1993,3.9,4568
*/

-- load the data from a csv file located in Amazon s3
raw_data = LOAD 's3://yifengspark/movies_data.csv' using PigStorage(',');

structured_data = FOREACH raw_data  GENERATE (int) $1 as id, $2 as movie_name, (int) $3 as year, (float) $4 as rating, (float) $5 as length;

-- data cleaning
filtered_data = FILTER structured_data BY rating is not null;


-- *** Task 1: fid the top-rating movie for each year ordered on year (ascending)
-- output table format: year, movie_id, move_name, rating

-- select columns
A1 = FOREACH filtered_data GENERATE year as year, id as id, movie_name as movie_name, rating as rating;

-- group rows based on year
B1 = GROUP A1 by year;

-- for each group (year), find the row with the max rating
C1 = FOREACH B1 {
	I1 = ORDER A1 BY rating DESC;
        -- only take the row with max rating
	J1 = LIMIT I1 1;
	GENERATE group, J1.(id, movie_name, rating);
};

-- store the result into a csv file
STORE C1 into 's3://yifengsparkoutput/task1_result.csv' using PigStorage(',');


-- *** Task 2: find the top-10 movies since 2005 order on rating (descending)
-- output result: id, movie_name, year, rating

-- data filtering
A2 = FILTER structured_data BY year > 2004;

-- descending ordered on rating
B2 = ORDER A2 by rating DESC;

-- choose top-10 movies
C2 = LIMIT B2 10;

-- store the result into a csv file
STORE C2 into 's3://yifengsparkoutput/task2_result.csv' using PigStorage(',');



-- *** Task 3: find the histogram of movie ratings
-- output result: rating_range (five bins), number_of_movies

-- convert double(rating) to int(rating)
A3 = FOREACH structured_data GENERATE (int) rating as rating_bin, id as id;

-- group on rating_bin
B3 = GROUP A3 by rating_bin;

-- count the number of movies in each bin
C3 = FOREACH B3 GENERATE group, count(id) as number_movies;

-- store the result into a csv file
STORE C3 into 's3://yifengsparkoutput/task3_result.csv' using PigStorage(',');
