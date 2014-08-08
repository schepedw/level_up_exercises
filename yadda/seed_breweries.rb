require 'set'
require 'faker'
require 'pg'
require 'pry'
conn = PG::Connection.open(:dbname => 'yadda')
10000.times do
conn.exec_params('insert into breweries(name, house_number, street, city, state, zipcode, 
        description, founding_year, created_by)
       values($1, $2, $3, $4, $5, $6, $7, $8, $9)',
       [Faker::Company.name,
        Faker::Address.building_number,
        Faker::Address.street_name,
        Faker::Address.city,
        Faker::Address.state_abbr,
        Faker::Address.zip[0..5].to_i,
        Faker::Lorem.sentence,
        (1800..2014).to_a.sample,
        (1..50).to_a.sample
] )
end
