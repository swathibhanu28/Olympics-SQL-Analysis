-- 1.	How many Olympics games have been held?
select
count(distinct games) as total_olympic_games
from olympics_history;

-- 2.	Extract all Olympics games held so far.
select
distinct year,season,city as all_olympic_games
from olympics_history
order by year;

-- 3.	Total no of nations who participated in each Olympics game?
with all_countries as
        (select games, nr.region
        from olympics_history oh
        join olympics_history_noc_regions nr ON nr.noc = oh.noc
        group by games, nr.region)
    select games, count(1) as total_countries_participated
    from all_countries
    group by games
    order by games;
    
-- 4.  Which year saw the highest and lowest no of countries participating in Olympics?
WITH all_nations AS (
    SELECT games, COUNT(DISTINCT noc) as total_countries
    FROM olympics_history
    GROUP BY games
)
SELECT *
FROM all_nations
WHERE total_countries = (SELECT MAX(total_countries) FROM all_nations)
   OR total_countries = (SELECT MIN(total_countries) FROM all_nations);    
    
-- 5.  Which nation has participated in all of the Olympic games?
with total_games as (
select distinct games as total_count
from olympics_history),

nation_wise_games_count as (
select re.region,
       count(distinct o.games) as no_of_games
from olympics_history o
join olympics_history_noc_regions re
on o.noc=re.noc
group by re.region)

select n.*
from nation_wise_games_count n
join total_games t
on n.no_of_games=t.total_count;


-- 6.  Find the Ratio of male and female athletes participated in all Olympic games
with cte1 as (select
count(case when sex='M' then 1 end) as male_count,
count(case when sex='F' then 1 end) as female_count
from olympics_history)
select (male_count/female_count)
from cte1;
    

-- 7.  Fetch the top 5 athletes who have won the most gold medals.
select
name,count(*) as total_gold_medals
from olympics_history
where medal ="Gold"
group by name
order by total_gold_medals desc
limit 5;   

-- 8.  Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)
select
name,count(*) as total_gold_medals
from olympics_history
where medal ="Gold" or medal="Sliver" or medal="bronze"
group by name
order by total_gold_medals desc
limit 5; 

-- 9.  Identify the sport which was played in all summer Olympics.
with t1 as (
    select count(distinct games) as total_summer_games
    from olympics_history 
    where season = 'summer'
),
t2 as (
    select sport, count(distinct games) as no_of_games
    from olympics_history 
    where season = 'summer'
    group by sport
)
select t2.*
from t2
join t1 on t1.total_summer_games = t2.no_of_games;


-- 10.  Which Sports were just played only once in the Olympics?
select 
sport,count(games) as cnt
from olympics_history
group by sport
having cnt=1;

-- 11. Fetch the total no of sports played in each Olympics game.
select
		games,count(distinct sport) as total_no_of_sports
from olympics_history
group by games;  


-- 12.  Fetch details of the oldest athletes to win a gold medal.
with cte1 as (
    select *,
           cast(case when age = 'na' then '0' else age end as unsigned) as cleaned_age
    from olympics_history
    where medal = 'gold'
)
select *
from temp
where cleaned_age = (select max(cleaned_age) from cte1);


-- 13. Fetch the top 5 most successful countries in Olympics.
select re.region,count(o.medal) as cnt
from olympics_history o
    join olympics_history_noc_regions re on o.noc = re.noc
where medal !="NA"
group by re.region
order by cnt desc
limit 5;


-- 14.  List the total gold, silver, and bronze medals won by each country.
select 
		re.region,
        count(case when o.medal="Gold" then 1 end) as Gold,
              count(case when o.medal="Silver" then 1 end) as silver,
			  count(case when o.medal="Bronze" then 1 end) as Bronze
from  olympics_history o
    join olympics_history_noc_regions re on o.noc = re.noc
group by re.region;            


-- 15.  List the total gold, silver and bronze medals won by each country corresponding to each Olympic games.
select 
		re.region,
        games,
        count(case when o.medal="Gold" then 1 end) as Gold,
              count(case when o.medal="Silver" then 1 end) as silver,
			  count(case when o.medal="Bronze" then 1 end) as Bronze
from  olympics_history o
    join olympics_history_noc_regions re on o.noc = re.noc
group by re.region,games;  



-- 16. Identify which country won the most gold, most silver and most bronze medals in each Olympic games.
with medal_tally as (
    select
        o.games,
        re.region,
        count(case when o.medal = 'Gold' then 1 end) as gold,
        count(case when o.medal = 'Silver' then 1 end) as silver,
        count(case when o.medal = 'Bronze' then 1 end) as bronze
    from olympics_history o
    join olympics_history_noc_regions re on o.noc = re.noc
    group by o.games, re.region)
select distinct
    games,
    first_value(region) over(partition by games order by gold desc) as max_gold_country,
    first_value(region) over(partition by games order by silver desc) as max_silver_country,
    first_value(region) over(partition by games order by bronze desc) as max_bronze_country
from medal_tally
order by games;
 
 
-- 17. Identify which country won the most gold, most silver, most bronze medals
--     and the most medals in each Olympic games.
with medal_tally as (
    select
        o.games,
        re.region,
        count(case when o.medal = 'Gold' then 1 end) as gold,
        count(case when o.medal = 'Silver' then 1 end) as silver,
        count(case when o.medal = 'Bronze' then 1 end) as bronze,
        count(case when o.medal != 'NA' then 1 end) as total_medals
    from olympics_history o
    join olympics_history_noc_regions re on o.noc = re.noc
    group by o.games, re.region)
select distinct
    games,
    first_value(region) over(partition by games order by gold desc) as max_gold_country,
    first_value(region) over(partition by games order by silver desc) as max_silver_country,
    first_value(region) over(partition by games order by bronze desc) as max_bronze_country,
    first_value(region) over(partition by games order by total_medals desc) as max_medals_country
from medal_tally
order by games;
 
 
-- 18. Which countries have never won gold medal but have won silver or bronze medals?
select
    re.region,
    count(case when o.medal = 'Gold' then 1 end) as gold,
    count(case when o.medal = 'Silver' then 1 end) as silver,
    count(case when o.medal = 'Bronze' then 1 end) as bronze
from olympics_history o
join olympics_history_noc_regions re on o.noc = re.noc
group by re.region
having gold = 0
and (silver > 0 or bronze > 0)
order by silver desc, bronze desc;
 
 
-- 19. In which Sport/event, India has won the highest number of medals?
select
    sport,
    count(*) as total_medals
from olympics_history
where noc = 'IND'
and medal != 'NA'
group by sport
order by total_medals desc
limit 1;
 
 
-- 20. Break down all Olympic games where India won medal for Hockey
--     and how many medals in each Olympic games.
select
    games,
    sport,
    count(*) as total_medals
from olympics_history
where noc = 'IND'
and sport = 'Hockey'
and medal != 'NA'
group by games, sport
order by games;



