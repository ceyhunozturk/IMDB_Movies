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
genres,
count(genres)
from 
having count(genres)>5


