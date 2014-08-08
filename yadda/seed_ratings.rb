require 'set'
require 'faker'
require 'pg'
require 'pry'
conn = PG::Connection.open(:dbname => 'yadda')
900000.times do
conn.exec_params('insert into ratings(user_id, beer_id, rating)
       values($1, $2, $3)',
       [1+rand(200000),
        1+rand(1000000),
        5*rand()
] )
end
