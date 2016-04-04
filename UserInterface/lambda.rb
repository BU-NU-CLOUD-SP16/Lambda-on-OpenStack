#lambda
require 'haml'
require 'zip'
require 'find'
require 'json/ext'
require 'sinatra'
require 'mongo'
require "./mongo.rb"

get "/lambda" do
	uname=params[:UserName]
 	a= []
	db = settings.mongo_db
	result = db[:mapping].find(:username => "#{uname}").each do |document|
		a.push(document)
	end
	if a==[]
  	return "No functions listed"
	else
  	return JSON.generate(a)
end	
end


 delete "/lambda" do
  filename=params[:FileName]
  uname=params[:UserName]
  db = settings.mongo_db
  db[:mapping].find(:username => "#{uname}",:filename =>"#{filename}").each do |document|
  db[:'fs.files'].delete_one(:_id => document[:_id])
  db[:'fs.chunks'].delete_one(:files_id => document[:_id])
  db[:mapping].delete_one(:_id => document[:_id] )
end  
  return "Function Deleted!"
end

post "/lambda" do 
  filename = params[:data][:filename]
  username=params[:UserName]
  eventtype=params[:EventType]
  eventsource=params[:EventSource]
  memory=params[:Memory]
  environment=params[:Environment]
  content_type :json
  db = settings.mongo_db
  n = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").count
  if (n > 0)
  	return "Duplicate Function. Please retry"  	
  else
  	fs_bucket = db.database.fs(read: { mode: :secondary })
  	file = File.open(params['data'][:tempfile], "r")
  	id = fs_bucket.upload_from_stream(params['data'][:filename], file)
  	file.close
  	result = db[:mapping].insert_one({"_id":id,
                                	    "filename": filename,
                                	    "username": username,
                                	    "eventType": eventtype,
                                	    "eventsource": eventsource,
                                	    "memory": memory,
                                	    "environment": environment,
					                            "sequence_count":0})
  {:_id=>id, :filename=>filename, :username=>username, :eventType=>eventtype, :eventsource=>eventsource, :memory=>memory, 
      :environment=>environment}.to_json  	
  end  
end


put "/lambda" do
  filename = params[:data][:filename]
  username=params[:UserName]
  eventtype=params[:EventType]
  eventsource=params[:EventSource]
  memory=params[:Memory]
  environment=params[:Environment]
  content_type :json
  db = settings.mongo_db
  db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").each do |document|
  db[:'fs.files'].delete_one(:_id => document[:_id])
  db[:'fs.chunks'].delete_one(:files_id => document[:_id])
  db[:mapping].delete_one(:_id => document[:_id] )
end  
    fs_bucket = db.database.fs(read: { mode: :secondary })
    file = File.open(params['data'][:tempfile], "r")
    id = fs_bucket.upload_from_stream(params['data'][:filename], file)
    file.close
    result = db[:mapping].insert_one({"_id":id,
                                	    "filename": filename,
                                	    "username": username,
                                	    "eventType": eventtype,
                                	    "eventsource": eventsource,
                                	    "memory": memory,
                                	    "environment": environment,
					                    "sequence_count":0})
  {:_id=>id, :filename=>filename, :username=>username, :eventType=>eventtype, :eventsource=>eventsource, :memory=>memory, 
  :environment=>environment}.to_json   
end 