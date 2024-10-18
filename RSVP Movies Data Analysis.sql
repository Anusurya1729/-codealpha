create database imdb;
use imdb;

CREATE TABLE movie ( 
id varchar(10) NOT NULL, 
title varchar(200) DEFAULT NULL, 
year INT DEFAULT NULL, 
date_published varchar(10) DEFAULT null, 
duration INT, country varchar(250), 
worlwide_gross_income varchar(30), 
languages varchar(200), 
production_company varchar(200),
PRIMARY KEY (id)) ;

CREATE TABLE genre ( 
movie_id VARCHAR(10), 
genre VARCHAR(20), 
PRIMARY KEY (movie_id, genre) );

CREATE TABLE director_mapping( 
movie_id VARCHAR(10), 
name_id VARCHAR(255), 
PRIMARY KEY (movie_id, name_id) );

CREATE TABLE role_mapping ( 
movie_id VARCHAR(10) NOT NULL, 
name_id VARCHAR(10) NOT NULL, 
category VARCHAR(10), 
PRIMARY KEY (movie_id, name_id) );

CREATE TABLE names ( 
id varchar(10) NOT NULL, 
name varchar(100) DEFAULT NULL, 
height int DEFAULT NULL, 
date_of_birth date DEFAULT null, 
known_for_movies varchar(100), 
PRIMARY KEY (id) );

CREATE TABLE ratings ( 
movie_id VARCHAR(10) NOT NULL, 
avg_rating DECIMAL(3,1), 
total_votes INT, 
median_rating INT, 
PRIMARY KEY (movie_id) );

LOAD DATA INFILE "D:\\role_mapping.csv"
INTO TABLE role_mapping
COLUMNS TERMINATED BY ','
IGNORE 1 LINES;

LOAD DATA INFILE "D:\movies.csv"
INTO TABLE movie
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

LOAD DATA INFILE "D:\genre.csv"
INTO TABLE genre
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

LOAD DATA INFILE "D:\\rating.csv"
INTO TABLE ratings
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

LOAD DATA INFILE "D:\\names.csv"
#ignore
INTO TABLE names
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

LOAD DATA INFILE "D:\director_mapping.csv"
#ignore
INTO TABLE director_mapping
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * from genre;
select * from movie;
select * from names;
select * from ratings;
select * from role_mapping;
select * from director_mapping;
#some validation of the movie table
select count(*) from movie;
select count(year) from movie where worlwide_gross_income = '';
select count(*) from movie where production_company = '';
select count(*) from movie where worlwide_gross_income  = '';

#Q1. Find the total number of rows in each table of the schema? 
select count(*) from movie;
select count(*) from genre;
select count(*) from names;
select count(*) from ratings;
select count(*) from role_mapping;
select count(*) from director_mapping;

#Q2. Which columns in the movie table have null values? 

SELECT count(*)
FROM movie
WHERE id is null
   or title IS NULL
   OR year IS NULL
   OR date_published IS NULL
   or duration is null
   or country is null
   or worlwide_gross_income
   or languages is null
   or production_company is null;

SELECT Sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
Sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) worlwide_gross_income_null_count,
 Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
 Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count FROM movie;

select date_published,month(str_to_date(date_published, '%d-%m-%Y'))as month_number,COUNT(id) as number_movie 
FROM movie GROUP BY month_number order by month_number;


#Q3. Find the total number of movies released each year? How does the trend look month wise?

SELECT 
   year, 
    MONTH(STR_TO_DATE(date_published, '%d-%m-%Y')) AS month_number, 
    COUNT(id) AS number_of_movies #--convert dta-pulished columns strin to date for fiend month number
FROM movie 
GROUP BY year, month_number 
ORDER BY year, month_number;


SELECT * from movie; 
#Q4. How many movies were produced in the USA or India in the year 2018?
select title,country,year,count(id) from movie where (country ='India' OR country='USA') and year=2018;

#Q5. Find the unique list of the genres present in the data set?
select genre,count(genre) as unique_list_of__genre from genre group by genre;

#Q6.Which genre had the highest number of movies produced overall?
select genre,count(movie_id) as number_of_movies from genre group by genre order by number_of_movies desc;


#Q7. How many movies belong to only one genre?

SELECT movie_id FROM genre
GROUP BY movie_id
HAVING COUNT(genre) = 1;#----one movie for genre

  select count(movie_id) as movie_count, genre from (SELECT movie_id,genre
FROM genre
GROUP BY movie_id
HAVING count(genre)= 1) as one_movies_for_genre;

#Q8.What is the average duration of movies in each genre?

select id,avg(duration) as avg_duration,g.genre 
from movie as m 
left join genre as g 
on g.movie_id=m.id 
group by genre;

#Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced?
 
WITH thriller_genre_rank AS ( SELECT genre, COUNT(movie_id), 
RANK() OVER(ORDER BY COUNT(movie_id) DESC) genre_rank FROM genre GROUP BY genre ) 
SELECT * FROM thriller_genre_rank WHERE genre like "%Thriller%";#-----useig CTE

select * from(SELECT genre, COUNT(movie_id), 
RANK() OVER(ORDER BY COUNT(movie_id) DESC) genre_rank FROM genre GROUP BY genre) as thriller_genre_rank 
where genre like '%Thriller%';#---USEING SUB QUERY

#Q10. Find the minimum and maximum values in each column of the ratings table except the movie_id column?
select min(avg_rating) as min_avg_rating,
       min(total_votes) as min_total_votes,
       min(median_rating) as min_median_rating from ratings;
       
select max(avg_rating) as max_avg_rating,
       max(total_votes) as max_total_votes,
       max(median_rating) as max_median_rating from ratings;


#Q11. Which are the top 10 movies based on average rating? 
select movie_id,avg_rating from ratings order by avg_rating desc limit 10;

#Q12. Summarise the ratings table based on the movie counts by median ratings.
select median_rating,count(movie_id) as movie_count from ratings group by median_rating order by movie_count desc;

#Q13. Which production house has produced the most number of hit movies (average rating > 8)?
select m.production_company, m.worlwide_gross_income,
count(m.id) as movie_count,r.avg_rating 
from movie as m inner join ratings as r on r.movie_id= m.id 
group by production_company having avg_rating > 8 
order by  worlwide_gross_income desc;

#Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
select count(m.id) as count_movie, g.genre, m.year,m.date_published from movie as m 
inner join genre as g on  g.movie_id=m.id 
where year=2017 and month(str_to_date(m.date_published, '%d-%m-%Y'))=3  group by genre;

#Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
select m.id,m.title, g. genre,avg(r.avg_rating) as avg_rating from movie as m 
join genre as g on g.movie_id=m.id
join ratings as r on r.movie_id=m.id
where m.title like 'The%'
and avg_rating > 8
group by g.genre;

#Q16. Of the movies released between 1 April 2017 and 1 April 2018, how many were given a median rating of 8?
select m.id,m.year,m.date_published,r.median_rating from movie as m 
join ratings r on r.movie_id=m.id 
where m.date_published between '01-04-2017' and '01-04-2018' 
group by m.id,m.date_published
having r.median_rating=8;

#Q17. Do German movies get more votes than Italian movies? 
select m.title,m.country, sum(r.total_votes) from movie as m 
join ratings as r on r.movie_id=m.id 
where m.country in ('Germany' ,'Italy')
group by m.country;

#Q18. Which columns in the names table have null values?
SELECT *
FROM names
WHERE id IS NULL
   OR name IS NULL
   OR height IS NULL
   OR date_of_birth IS NULL
   OR known_for_movies IS NULL;
    
#Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
select d.*,g.genre,avg(r.avg_rating) as avg_rating from director_mapping as d 
join genre as g on g.movie_id=d.movie_id
join ratings as r on r.movie_id=g.movie_id
where avg_rating > 8 
group by name_id
order by avg_rating desc limit 3 ;


#Q20. Who are the top two actors whose movies have a median rating >= 8?
select d.*,r.median_rating from director_mapping as d 
join ratings as r on r.movie_id=d.movie_id
where median_rating >= 8 
group by name_id
order by median_rating desc limit 2 ;

#Q21. Which are the top three production houses based on the number of votes received by their movies? 
select id,production_company,r.total_votes from movie as m
join ratings as r on r.movie_id=m.id group by m.production_company
order by total_votes desc limit 3;


#Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
select d.name_id,m. country,avg(r.avg_rating) as avg_rating 
from director_mapping as d 
join movie as m on m.id=d.movie_id 
join ratings as r on r. movie_id=m.id
where m.country='india'
group by d.name_id
order by avg_rating desc limit 1;

#Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings?
select m.id,d.name_id,m.languages,m.country,
avg(r.avg_rating) as avg_rating from director_mapping as d
join movie as m on m.id=d.movie_id
join ratings as r on r.movie_id=m.id
where m.languages='Hindi' and m.country='India'
group by d.name_id
order by avg_rating desc 
limit 5 ;


#Q24. Select thriller movies as per avg rating and classify them in the following category:
 #       Rating > 8: Superhit movies
   #     Rating between 7 and 8: Hit movies
    #    Rating between 5 and 7: One-time-watch movies
     #   Rating < 5: Flop movies  ?
	
SELECT title As movie_name, avg_rating, 
CASE WHEN avg_rating > 8 THEN "Superhit movies" 
WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies" 
WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies" 
ELSE "Flop Movies" END AS avg_rating_category FROM movie AS m 
INNER JOIN genre AS g ON m.id = g.movie_id 
INNER JOIN ratings r ON r.movie_id = m.id WHERE genre="thriller";

update genre set genre =trim(genre);
#Q25. What is the genre-wise running total and moving average of the average movie duration?
select count(m.id) as total_movie, 
g.genre,avg(m.duration) from movie as m 
join genre as g on m.id=g.movie_id 
group by g.genre;
----------
WITH genre_avg AS (
    SELECT 
        g.genre,
        m.duration,
        AVG(m.duration) OVER (PARTITION BY g.genre) AS avg_duration,
        COUNT(m.id) OVER (PARTITION BY g.genre ORDER BY m.id ) AS running_total
    FROM movie AS m
    JOIN genre AS g 
    ON m.id = g.movie_id
)
SELECT 
    genre,
    running_total,
    AVG(duration) OVER (PARTITION BY genre 
    ORDER BY running_total ) AS moving_average
FROM 
    genre_avg; 

#Q26. Which are the five highest-grossing movies of each year that belong to the top three genres?

WITH top_3_genre AS( SELECT genre, COUNT(movie_id) as movie_count, 
RANK() OVER(ORDER BY COUNT(movie_id) DESC) genre_rank 
FROM genre GROUP BY genre limit 3 ),

find_rank AS( SELECT genre, year, title AS movie_name, worlwide_gross_income, 
RANK() OVER(ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie AS m 
INNER JOIN genre AS g ON m.id=g.movie_id 
WHERE genre IN (SELECT genre FROM top_3_genre)
)
SELECT * FROM find_rank WHERE movie_rank<=5;

#Q27. Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
select m.id,m.production_company,count(*) as hit_movie from movie m
join ratings r on r.movie_id=m.id
where r.median_rating>=8
group by m.production_company
order by hit_movie desc limit 2 offset 1;


#Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
SELECT m.id,n.name,COUNT(*) AS super_hit_movies 
FROM director_mapping d
join movie m on m.id=d.movie_id 
join ratings r on r.movie_id=m.id 
join genre g on g.movie_id=m.id
join names n on n.id=m.id
WHERE genre='Drama' and r.avg_rating > 8
group by n.name
ORDER BY super_hit_movies DESC
LIMIT 3;



