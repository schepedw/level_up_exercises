drop view if exists best_of_brewery;
drop view if exists six_month_avg;
drop view if exists suggestions;
drop view if exists beer_avgs;

create or replace function recent_score(time_lapse interval) returns table(beer_id int, avg_score numeric) as $$
	select beers.id, round(cast(avg(ratings.rating) as numeric),2) as rating
	from beers right join ratings on beers.id = ratings.beer_id
	where ratings.created_at > now() - time_lapse
	group by beers.id;
$$ language SQL;

create view beer_avgs as 
select beer_id as id, avg_score 
from recent_score(interval '100 years');

create view best_of_brewery as 
select breweries.name as brewery_name, beers.*, beer_avgs.avg_score 
from beers join breweries on (beers.brewery_id = breweries.id)
	join beer_avgs on (beers.id = beer_avgs.id)
order by brewery_name, beer_avgs.avg_score desc;

create view six_month_avg as
select beers.*, rs.avg_score
from recent_score(interval '6 months') rs inner join beers on rs.beer_id = beers.id;

create view suggestions as 
select beers.*, beer_avgs.avg_score
from beers inner join beer_avgs on beers.id = beer_avgs.id
where beer_avgs.avg_score > 4.0
order by beers.style, random();
