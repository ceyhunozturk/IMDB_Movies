select * from actors;
select * from directors;
select * from genre;
select * from keywords;
select * from movies;
select * from ratings;

-- 1.What are all Directors names and total count of unique directors in director table ?

select
directors
from directors;

select count(distinct directors) total_number from directors;

-- 2.What are all actoss names and total count of unique actors in director table ?

select
actor
from actors;

select count(distinct actor) total_number from actors;

-- 3.What is the colour,languages,country,title_year distribution of movies in the movies table ?
select
color,
count(color) total_number
from movies  
group by 1;

select
languages,
count(languages) total_number
from movies  
group by 1
order by 2 desc;

-- 4.What is the highest and lowest grossing,highest and lowest budget movies in Database ?

select
*
from movies
where gross=(select max(gross) from movies);

select
*
from movies
where gross=(select min(gross) from movies);

select
*
from movies
where budget=(select max(budget) from movies);

select
*
from movies
where budget=(select min(budget) from movies where budget>0);

-- 5. Retrieve a list of movie titles along with a column indicating whether the duration is above 120 minutes or not

select
movie_title,
case when duration>120 then 'Above120mins' else 'Below120mins' end as category
from movies;

-- 6.Find the top 5 genres based on the number of movies released on last five years

select
genres,
count(*)
from movies where title_year>(select max(title_year) from movies)-5
group by 1
order by 2 desc;

-- 7.Retrieve the movie titles directed by a director whose average movie duration is above the overall average duration

select movie_title
from movies 
where director_id in 
(select director_id from movies 
group by 1 
having avg(duration)>(select avg(duration) from movies));

-- 8.Calculate the average budget of the of movies over the last 3 years, including the average budget of the year

select
movie_title,
avg(budget) over (order by title_year rows between 2 preceding and current row) as avg_budget_last_3years
from movies 
where title_year is not null;

-- 9. Retrieve a list of movies with their genres, including only those genres that have more than 5 movies.

select
movie_title,
genres
from movies where genres in (select genres from movies group by 1 having count(genres)>5)
order by 2,1;

-- 10. Find the directors who have atleast 3 movies have average imdb score above 7

select
d.directors,
count(*) as movie_count,
round(avg(imdb_score),2) as avg_imdb_score
from movies m inner join directors d on d.d_id=m.director_id
group by 1
having count(*)>=3 and round(avg(imdb_score),2)>7
order by 3 desc;

-- 11. List the top 3 actors who have appeared in the most movies, and for each actor, provide the average imdb score of the movies they appeared in ?

select
a.actor,
count(*) as movie_count,
round(avg(imdb_score),2) as avg_imdb_score
from actors a 
left join movies m on concat('|',m.actors,'|') like concat ('%|',a.actor,'%|')
group by a.actor
order by 2 desc
limit 3;

-- 12. For each year, find the movie with highest gross,and retrieve the second highest gross in the same result

with ranks as (
select
title_year,
movie_title,
budget,
row_number () over (partition by title_year order by budget desc) new_rank
from movies
where budget>0
order by title_year asc )

select title_year,
       max(case when new_rank=1 then movie_title end) as highest_grossing_movie,
       max(case when new_rank=2 then movie_title end) as second_highest_grossing_movie
       from ranks
       where new_rank<=2
       group by 1;

-- 13. Create a stored procedure that takes a directors id as input and retuns the average imdb score of the movies directed by the director.

delimiter //

CREATE PROCEDURE Avg_imdbscore (in d_id varchar(255))
begin
     select avg(imdb_score)
     from movies
     where director_id=d_id;
     end //
     
delimiter ;

call avg_imdbscore('d1002');

-- 14. Retrieve the top 3 movies based on imdb score, and include their ranking

select movie_title,ranking from (select movie_title,imdb_score,
	   rank () over (order by imdb_score desc) ranking
       from movies) m
       where ranking<=3;
       
-- 15. For each director, list their movies along with the imdb score and the ranking of each movie based on imdb score;

select
directors,
movie_title,
imdb_score,
rank() over (partition by directors order by imdb_score desc) ranking
from movies m inner join directors d on m.director_id=d.d_id
where imdb_score is not null
order by director_id,imdb_score desc
