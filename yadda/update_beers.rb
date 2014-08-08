require 'set'
require 'faker'
require 'pg'
require 'pry'
conn = PG::Connection.open(:dbname => 'yadda')
1000000.times do |i|
  conn.exec_params("update beers set name = $1 where id =$2",[Faker::Lorem.word,i])
end
