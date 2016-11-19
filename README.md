# Data-Analysis-with-Hive-and-Pig-on-Amazon-EMR-Hadoop-Cluster
This project aims to analize the movie rating data using Pig or Hive scripts on a Amazon EMR Hadoop cluster.

# Dataset

The dataset contains 49,590 rows, each of which has the format of: id, movie_name, year, rating, length. An example of a row is as follows:

21,The Nightmare Before Christmas,1993,3.9,4568

# Data Analysis on Amazon EMR

1. Sign in to Amazon AWS console

2. Create a Haddop cluster

3. Upload the Pig and Hive script and the data file to Amazon S3 bucket

4. On the page of Hadoop cluster, click "Step" to submit the job (e.g., Pig or Hive script)

5. After the job is completed, check the result from S3 bucket

# Data Analysis Tasks

Both the Pig script (movie_data_analysis_with_hive.pig) and the Hive script (movie_data_analysis_with_hive.sql) accomplished the same three tasks, as given below:

1. find the top-rating movie for each year and list them in an ascending order based on year 

2. find the top-10 movies since 2005 and list them in a descending order based on rating

3. find the histogram of movie ratings



