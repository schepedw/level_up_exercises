require 'set'
require 'faker'
require 'pg'
require 'pry'
conn = PG::Connection.open(:dbname => 'yadda')
200000.times do
  conn.exec_params('insert into users(first_name, last_name, house_number, street, zipcode, city, state, birthday) 
       values($1, $2, $3, $4, $5, $6, $7, $8)',
       [Faker::Name.first_name,
        Faker::Name.last_name,
        Faker::Address.building_number,
        Faker::Address.street_name,
        Faker::Address.zip[0..5].to_i,
        Faker::Address.city,
        Faker::Address.state_abbr,
        Date.today-rand(10000)])
end
