require 'set'
require 'faker'
require 'pg'
require 'pry'
conn = PG::Connection.open(:dbname => 'yadda')
800000.times do
  conn.exec_params('insert into beers(name, brewery_id, style, description, brewing_year, created_by) 
       values($1, $2, $3, $4, $5, $6)',
       [Faker::Lorem.word,
        1 + rand(10000),
        Faker::Lorem.word,
        Faker::Lorem.sentence,
        1970 + rand(44),
        1 + rand(200000)])
end
