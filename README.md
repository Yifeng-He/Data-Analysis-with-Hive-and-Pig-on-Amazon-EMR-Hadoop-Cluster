# Data-Analysis-with-Hive-and-Pig-on-Amazon-EMR-Hadoop-Cluster
This project aims to analize the movie rating data using Pig or Hive scripts on a Amazon EMR Hadoop cluster.

# Dataset

The dataset contains 49,590 rows, each of which has the format of: id, movie_name, year, rating, length. An example of a row is as follows:

21,The Nightmare Before Christmas,1993,3.9,4568

# Data Analysis on Amazon EMR

1. Sign in to Amazon AWS console

2. Create a Haddop cluster

3. Upload the Pig and Hive script and the data file to Amazon S3 bucket

4. On the page of Haddop cluster, click "Step" to submit the job (e.g., Pig or Hive script)

5. After the job is completed, check the result from S3 bucket
