drop table if exists ratings;
drop table if exists beers;
drop table if exists breweries;
drop table if exists users;

create table users(
  id serial primary key,
  first_name varchar(20),
  last_name varchar(20),
  house_number varchar(10)  not null,
  suite_number varchar(20),
  street varchar(40)  not null,
  city varchar(40) not null,
  state char(2)  not null,
  zipcode int  not null,
  birthday date not null,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone 
  --Doesn't make sense to have created/updated by for user
);

create table breweries(
  id serial primary key,
  name  varchar(40)  not null,
  house_number varchar(10)  not null,
  suite_number varchar(20),
  street varchar(40)  not null,
  city varchar(40) not null,
  state char(2)  not null,
  zipcode int  not null,
  description varchar(200),
  founding_year int,
  created_by int references users(id) not null,
  updated_by int references users(id),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone
); 

create table beers(
  id serial primary key,
  brewery_id int references breweries(id) on delete restrict,
  style varchar(30)  not null,
  description varchar(200),
  brewing_year int,  
  created_by int references users(id) not null,
  updated_by int references users(id),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone
);

create table ratings(
  user_id int references users(id) on delete set null,
  beer_id int references beers(id) on delete cascade,
  rating float not null,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone  -- A rating should always be created/updated by the user already associated with it. Better to enforce that at app level than have repetative fields here
);

