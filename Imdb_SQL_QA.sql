USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
 
-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- 1.using table schema
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

-- 2.Approach count rows in each table 
SELECT COUNT(*) FROM MOVIE;
-- Number of rows = 7997

SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Number of rows = 3867

SELECT COUNT(*) FROM GENRE;
-- Number of rows = 14662

SELECT COUNT(*) FROM NAMES;
-- Number of rows = 25735

SELECT COUNT(*) FROM RATINGS;
-- Number of rows = 7997

SELECT COUNT(*) FROM ROLE_MAPPING;
-- Number of rows = 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- 1.approach count null values in each columns by using simple count for each col.
SELECT COUNT(*) AS id_null_cnt
FROM movie
WHERE ID IS NULL;

SELECT COUNT(*) AS title_null_cnt
FROM movie
WHERE title IS NULL;

SELECT COUNT(*) AS year_null_cnt
FROM movie
WHERE year IS NULL;

SELECT COUNT(*) AS date_published_null_cnt
FROM movie
WHERE date_published IS NULL;

SELECT COUNT(*) AS duration_null_cnt
FROM movie
WHERE duration IS NULL;

SELECT COUNT(*) AS country_null_cnt
FROM movie
WHERE country IS NULL;

SELECT COUNT(*) AS wgi_null_cnt
FROM movie
WHERE worlwide_gross_income IS NULL;

SELECT COUNT(*) AS languages_null_cnt
FROM movie
WHERE languages IS NULL;

SELECT COUNT(*) AS production_company_null_cnt
FROM movie
WHERE production_company IS NULL;

-- 1.approach count null values in each columns by using CASE.
SELECT  SUM(CASE
				WHEN id is null THEN 1 
                ELSE 0
                END) AS id_null_cnt,
		SUM(CASE
				WHEN title is null THEN 1 
                ELSE 0
                END) AS title_null_cnt,
		SUM(CASE
				WHEN year is null THEN 1 
                ELSE 0
                END) AS year_null_cnt,
		SUM(CASE
				WHEN date_published is null THEN 1 
                ELSE 0
                END) AS date_null_cnt,
		SUM(CASE
				WHEN duration is null THEN 1 
                ELSE 0
                END) AS duration_null_cnt,
		SUM(CASE
				WHEN country is null THEN 1 
                ELSE 0
                END) AS country_null_cnt,
		SUM(CASE
				WHEN worlwide_gross_income is null THEN 1 
                ELSE 0
                END) AS wgi_null_cnt,
		SUM(CASE
				WHEN languages is null THEN 1 
                ELSE 0
                END) AS languages_null_cnt,
		SUM(CASE
				WHEN production_company is null THEN 1 
                ELSE 0
                END) AS production_company_null_cnt
	FROM movie;

-- Country, worlwide_gross_income, languages and production_company columns have NULL values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Number of movies released each year
SELECT year,
		COUNT(id) AS number_of_movies
FROM movie
GROUP BY year;


-- Number of movies released each month
SELECT month(date_published) AS month_num,
		COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY number_of_movies DESC;

-- Highest number of movies were released in 2017 And The highest number of movies is produced in the month of March. 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- 1.USING REGEXP:Pattern matching using LIKE operator for country column
SELECT Count(id) AS number_of_movies, year
FROM   movie
WHERE country Regexp 'USA|INDIA'
       AND year = 2019;
       
-- 1.USING Pattern matching using LIKE operator for country column
SELECT Count(id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
       
-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;

-- Here 13 genres Movies belong to the dataset.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
		COUNT(id) AS movie_cnt
FROM movie AS m
		INNER JOIN genre AS g
        ON m.id=g.movie_id
GROUP BY genre
ORDER BY movie_cnt DESC
LIMIT 1;

-- 4285 Drama movies were produced in total and are the highest among all genres. 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

--  Find movies which belong to only one genre
-- Grouping rows based on movie id and finding the distinct number of genre each movie
-- Using the result of CTE.

WITH one_genre_movie AS
(
	SELECT movie_id, 
			COUNT(genre) AS number_of_movies
	FROM genre
	GROUP BY movie_id
	HAVING number_of_movies=1
)
SELECT COUNT(movie_id) AS number_of_movies
FROM one_genre_movie;


-- 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Finding the average duration of movies by grouping the genres that movies
SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration
FROM movie AS m
		INNER JOIN genre AS g
			ON m.id=g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- CTE : Finds the rank of each genre based on the number of movies
-- Select query displays the genre rank 
-- The number of movies belonging to Thriller genre
WITH Gen_thrill_movie AS(
	SELECT genre,
			COUNT(movie_id) AS movie_count,
			RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM genre
    
	GROUP BY genre)
SELECT * FROM Gen_thrill_movie
WHERE genre="thriller";

-- Thriller has rank=3 and movie count of 1484

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Using MIN and MAX functions for the quer
SELECT MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
		MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
		MAX(median_rating) AS max_median_rating
FROM ratings;

--  1.min_avg_rating- 1.0
-- 	2.max_avg_rating- 10.0
--  3.min_total_votes- 100
--  4.max_total_votes- 725138
--  5.min_median_rating- 1
--  6.max_median_rating- 10



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too 

-- Find the rank of each movie based on it's average rating
-- Display the top 10 movies using LIMIT clause
  
-- 1.Approch using RANK()
SELECT title,
		avg_rating,
		RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
	INNER JOIN ratings AS r
		ON m.id=r.movie_id
LIMIT 10;

-- 1.Approch using DENSE_RANK()
SELECT title,
		avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
	INNER JOIN ratings AS r
	ON m.id=r.movie_id
LIMIT 10;

-- top 10 movies can also be displayed using WHERE caluse with CTE
WITH MOVIE_RANK AS
(
SELECT     title,
           avg_rating,
           ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings AS r
INNER JOIN movie  AS m
ON         m.id = r.movie_id
)
SELECT * FROM MOVIE_RANK 
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Finding the number of movies based on median rating and then use sort.

SELECT median_rating, 
	COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

-- Here median_rating 7 has heigher movie_count 2257 followed by 6,8.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- CTE: Find production company based on movie count with average rating > 8 using RANK function.
--  CTE to find the production company with rank=1
WITH Hit_movies AS(
	SELECT production_company, 
			COUNT(movie_id) AS movie_count,
			RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
	FROM movie m
		INNER JOIN ratings r
			ON m.id=r.movie_id
	WHERE avg_rating >8 AND production_company IS NOT NULL
	GROUP BY production_company)
SELECT * FROM Hit_movies
WHERE prod_company_rank=1;

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Here you find 
-- 1. Number of movies released in each genre 
-- 2. During March 2017 
-- 3. In the USA  (LIKE operator )
-- 4. Movies had more than 1,000 votes

SELECT genre,
		COUNT(id) AS movie_count
FROM movie AS m
		INNER JOIN genre AS g
			ON m.id=g.movie_id
		INNER JOIN ratings AS r
			ON m.id=r.movie_id
WHERE year = 2017 
	AND Month(date_published)=3 
	AND  country LIKE "%USA%" 
	AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes

-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Query to find:
-- 1. Number of movies of each genre that start with the word ‘The’  using LIKE.
-- 2. Which have an average rating > 8?
-- 3.Grouping by title  order by avg rating.
SELECT  title,
		avg_rating,
			genre
FROM movie AS m
		INNER JOIN genre AS g
			ON m.id=g.movie_id
		INNER JOIN ratings AS r
			ON m.id=r.movie_id
WHERE title LIKE 'The%'
		AND avg_rating >8
GROUP BY title
ORDER BY avg_rating DESC;

-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.
-- The top 3 movies belogns Drama genres.



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Use BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019 and median rating = 8

SELECT median_rating,
		COUNT(*) AS movie_count
FROM movie AS m
INNER JOIN ratings AS r
			ON m.id=r.movie_id
WHERE date_published BETWEEN  "2018-04-01" AND "2019-04-01"
        AND median_rating=8
GROUP BY median_rating;

-- Total 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
 

-- 1.Approach :  USING UNION FOR BOTH languages
SELECT languages, 
	SUM(total_votes)  AS Total_votes
FROM movie AS m
	INNER JOIN ratings AS r
			ON m.id=r.movie_id
WHERE languages LIKE '%German%'
UNION
SELECT languages, 
	SUM(total_votes)  AS Total_votes
FROM movie AS m
	INNER JOIN ratings AS r
			ON m.id=r.movie_id
WHERE languages LIKE '%Italian%'
ORDER BY Total_votes DESC;

-- -- Approach 2: By CTE'S
WITH lang_sumary AS(
		SELECT languages, SUM(total_votes)  AS Total_votes
		FROM movie AS m
		INNER JOIN ratings AS r
					ON m.id=r.movie_id
		WHERE languages LIKE '%German%'
		UNION
		SELECT languages, SUM(total_votes)  AS Total_votes
		FROM movie AS m
		INNER JOIN ratings AS r
					ON m.id=r.movie_id
		WHERE languages LIKE '%Italian%'),
lang_vote AS(
		SELECT languages FROM lang_sumary
		ORDER BY Total_votes DESC
		LIMIT 1)
SELECT IF (languages LIKE 'GERMAN' , 'YES', 'NO') AS ANSWER
FROM lang_vote ;     

-- By observation, German movies received the highest number of votes when  against italian language.
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- 1.Find NULL counts for columns of names table using CASE statements
SELECT
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- Height, date_of_birth, known_for_movies columns contain NULLS
-- name dont have null values

-- 2.Aproach :Aproach Counts null vallue in each column
SELECT Count(*) AS name_nulls
FROM   names
WHERE  name IS NULL;

SELECT Count(*) AS height_nulls
FROM   names
WHERE  height IS NULL;

SELECT Count(*) AS date_of_birth_nulls
FROM   names
WHERE  date_of_birth IS NULL;

SELECT Count(*) AS known_for_movies_nulls
FROM   names
WHERE  known_for_movies IS NULL;

-- Height, date_of_birth, known_for_movies columns contain NULLS
-- no null in the name col.

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1.find top 3 genre using rank().
-- 2.find top 3 direct using rank() with genre 
-- 3.use CTE's for both
-- 4.select and order them

WITH Top_3_Gen AS
		(
		SELECT g.genre,
				COUNT(g.movie_id) As movie_count,
		RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS gen_rank
		FROM genre AS g
				INNER JOIN ratings AS r
					ON g.movie_id=r.movie_id
		WHERE avg_rating>8
		GROUP BY g.genre
		ORDER BY movie_count DESC
		LIMIT 3
        ),
			Top_3_director AS
			( SELECT n.name AS director_name,
						COUNT(dm.movie_id) AS movie_count,
						RANK() OVER(ORDER BY COUNT(dm.movie_id) DESC) AS directr_rank
			FROM names AS n
					INNER JOIN director_mapping AS dm
						ON n.id=dm.name_id
					INNER JOIN ratings AS r
						ON dm.movie_id=r.movie_id
					INNER JOIN genre AS g
						ON dm.movie_id=g.movie_id,
                        Top_3_Gen					
			WHERE r.avg_rating>8 AND g.genre IN (Top_3_Gen.genre)
            GROUP BY n.name
            ORDER BY  movie_count  DESC
			)
select * 
FROM Top_3_director
WHERE directr_rank<=3
ORDER BY directr_rank, director_name
LIMIT 3;


-- James Mangold , Anthony Russo and Joe Russo are top three directors in the top three genres whose movies have an average rating > 8


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name As actor_name,
		COUNT(movie_id) AS movie_count 
FROM role_mapping AS rm
		INNER JOIN ratings AS r
			USING(movie_id)
		INNER JOIN movie AS m
			ON m.id=rm.movie_id
		INNER JOIN names AS n
			ON n.id=rm.name_id
WHERE median_rating>=8
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;

-- Here we found top 2 actors are Mammootty and Mohanlal respect movie count 8,5.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:	

SELECT production_company,
		SUM(total_votes) AS vote_count,
		RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
		INNER JOIN ratings AS r
			ON m.id=r.movie_id
GROUP BY production_company
ORDER BY vote_count DESC
LIMIT 3;
-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH Least_5_mv_cnt AS
		(SELECT n.name AS actor_name,total_votes,
				COUNT(m.id) AS movie_count,
				ROUND(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
						   actor_avg_rating
		FROM movie AS m
				INNER JOIN ratings AS r
					ON m.id=r.movie_id
				INNER JOIN role_mapping AS rm
					ON m.id=rm.movie_id
				INNER JOIN names AS n
					ON rm.name_id=n.id		
		WHERE category="actor" 
				AND country="India"
		GROUP BY name
		HAVING movie_count>=5)
	SELECT *, 
			RANK() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
            FROM Least_5_mv_cnt;

-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu as per avg rating and movie count.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH Least_3_mv_cnt AS
		(SELECT n.name AS actress_name,total_votes,
				COUNT(m.id) AS movie_count,
				ROUND(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
						   actor_avg_rating
		FROM movie AS m
				INNER JOIN ratings AS r
					ON m.id=r.movie_id
				INNER JOIN role_mapping AS rm
					ON m.id=rm.movie_id
				INNER JOIN names AS n
					ON rm.name_id=n.id		
		WHERE category="actress" 
				AND country="India"
                AND languages  LIKE "%Hindi%"
		GROUP BY name
		HAVING movie_count>=3)
	SELECT *, 
			RANK() OVER(ORDER BY actor_avg_rating DESC) AS actress_rank
            FROM Least_3_mv_cnt
            LIMIT 5;
-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Using CASE statements to classify thriller movies as per avg rating 

WITH Avg_thrill_movie AS(
		SELECT DISTINCT title,avg_rating
		FROM movie AS m
					INNER JOIN ratings AS r
						ON m.id=r.movie_id 
					INNER JOIN genre AS g
						ON m.id=g.movie_id 
		WHERE genre LIKE "%thriller%")
SELECT *,
		CASE 
			WHEN avg_rating >8 THEN 'Superhit movies'
			WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
			WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
			END AS Avg_category_div
FROM Avg_thrill_movie;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- 1.find genre,avg rating 
-- 2.using UNBOUNDED PRECEDING canculate running_total_duration
-- 3.using 10 PRECEDING canculate moving_avg_duration

SELECT genre,
			ROUND(AVG(duration),2) AS avg_duration,
            SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING ) 'running_total_duration',
            AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING )  'moving_avg_duration'
FROM movie AS m
		INNER JOIN genre AS g
			ON m.id=g.movie_id
GROUP BY genre
ORDER BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- With converting $ to INR using cast.
-- Top 3 Genres based on most number of movies
WITH top_genres AS
(
           SELECT     genre,
                      Count(m.id)   AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie    AS m
           INNER JOIN genre    AS g
           ON         g.movie_id = m.id
		
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worldwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie   AS m
           INNER JOIN genre  AS g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
						SELECT genre
						FROM   top_genres)
            GROUP BY   movie_name
           )
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;

-- Thriller	2017	The Fate of the Furious	1236005118
-- Comedy	2017	Despicable Me 3	1034799409
-- Comedy	2017	Jumanji: Welcome to the Jungle	962102237
-- Drama	2017	Zhan lang II	870325439
-- Comedy	2017	Guardians of the Galaxy Vol. 2	863756051


-- Without converting $ to INR

WITH top_3_genre AS
( 	
	SELECT genre, 
		COUNT(movie_id) AS number_of_movies,
		Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
    FROM genre AS g
		INNER JOIN movie AS m
			ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5_movies AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income AS worldwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)

SELECT *
FROM top_5_movies
WHERE movie_rank<=5;

-- Top 3 genere based on most number of movies 
		-- 'Drama', '2017', 'Shatamanam Bhavati'
        -- 'Drama', '2017', 'Winner'
        -- 'Drama', '2017', 'Thank You for Your Service'







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
		COUNT(id) AS movie_count,
RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie AS m
		INNER join ratings AS r
			ON m.id=r.movie_id
WHERE median_rating>=8 
		AND production_company IS NOT NULL 
		AND Position(',' IN languages) > 0
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 2;

-- top 2 production_company are star Cinema,Twentieth century Fox respect to movie count 7,4.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH Top_3_acts_rank AS(
		SELECT name as actress_name,
				total_votes,
				COUNT(m.id) AS movie_count, 
				ROUND(SUM(avg_rating*total_votes )/SUM(total_votes),2) AS actress_avg_rating
		FROM movie AS  m
				INNER JOIN genre AS g
					ON m.id=g.movie_id
				INNER JOIN role_mapping AS rm
					ON m.id=rm.movie_id
				INNER JOIN names AS n
					ON n.id=rm.name_id
				INNER JOIN ratings AS r
					ON m.id=r.movie_id
		WHERE category="actress" 
				AND avg_rating>8 
				AND genre="drama"
		GROUP BY actress_name)
SELECT *,
		RANK() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM Top_3_acts_rank 
LIMIT 3;

-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- 1.Approach:			
		-- 1.find next date using LEAD() 
		-- 2.calculate date difference using Datediff()
		-- 3.Apply CTE's and apply limit clause

WITH Next_publish_detail AS(
		SELECT dm.name_id,
			 name,
			 dm.movie_id,
			 duration,
			 r.avg_rating,
			 total_votes,
			 m.date_published,
			 LEAD(date_published,1) OVER(PARTITION  BY  dm.name_id ORDER BY date_published, movie_id) AS next_date_publish
             
		FROM director_mapping AS dm
			INNER JOIN names  AS n
				ON dm.name_id=n.id
			INNER JOIN movie  AS m
				ON dm.movie_id=m.id
			INNER JOIN ratings  AS r
				ON r.movie_id=m.id),Date_difference_tbl AS(
SELECT *,
		Datediff(next_date_publish,date_published) AS date_diff
FROM Next_publish_detail)
SELECT name_id AS director_id,
		 name AS director_name,
        COUNT(movie_id) AS number_of_movies,
        ROUND(AVG(date_diff),2)  AS avg_inter_movie_days,
        ROUND(AVG(avg_rating),2) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
        
FROM Date_difference_tbl
GROUP BY director_id
ORDER BY number_of_movies DESC 
LIMIT 9;


-- 2.Approach:			
		-- 1.find next date using LEAD() 
		-- 2.calculate date difference using Datediff()
        -- 2.calculate Avg intern  difference using Datediff()
		-- 3.Apply CTE's, use ROW_NUMBER() and apply limit clause

WITH movie_date_info_tbl AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info_tbl
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 result_tbl_avg_inter AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM result_tbl_avg_inter
 LIMIT 9;

-- Here we have top 9 director_name 'Andrew Jones'followed by 'A.L. Vijay' etc.

