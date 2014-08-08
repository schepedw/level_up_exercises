drop trigger if exists update_users_time on users;
drop trigger if exists update_breweries_time on breweries;
drop trigger if exists update_beers_time on beers;
drop trigger if exists update_ratings_time on ratings;
drop trigger if exists update_breweries_user on breweries;
drop trigger if exists update_beers_user on beers;

create or replace function update_time() returns trigger as 
  $update_time$
    begin
      NEW.updated_at := now();
      return NEW;
    end;
  $update_time$
language plpgsql;

create or replace function update_user() returns trigger as 
  $update_user$
    begin
      NEW.updated_by := current_user;
      return NEW;
    end;
  $update_user$
language plpgsql;

create trigger update_users_time before update on users for each row execute procedure update_time();
create trigger update_breweries_time before update on breweries for each row execute procedure update_time();
create trigger update_beers_time before update on beers for each row execute procedure update_time();
create trigger update_ratings_time before update on ratings for each row execute procedure update_time();
create trigger update_breweries_user before update on breweries for each row execute procedure update_user();
create trigger update_beers_user before update on beers for each row execute procedure update_user();
insert into users(first_name, last_name, house_number, street, zipcode, city, state, birthday) 
	values('Daniel', 'Schepers', '510 N', 'Weisheit Dr.', 47546, 'Jasper', 'IN', '1992-02-12');
update users set house_number='30 E' where users.birthday = '1992-02-12';
select * from users;