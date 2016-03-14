require 'mongo'
require 'json/ext' # required for .to_json


configure do
  db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'lambdaD')  
  set :mongo_db, db
end