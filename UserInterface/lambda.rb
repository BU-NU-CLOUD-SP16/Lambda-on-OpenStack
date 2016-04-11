#lambda
require 'haml'
require 'zip'
require 'find'
require 'json/ext'
require 'sinatra'
require 'mongo'
require "./mongo.rb"

get "/lambda/:UserName" do
	uname=params[:UserName]
 	a= []
	db = settings.mongo_db
	result = db[:mapping].find(:username => "#{uname}").each do |document|
		a.push(document.to_json)
	end
	if a==[]
  	return "No functions listed"
	else
  	return a
end	
end

get "/lambda/:UserName/:FileName" do
  uname=params[:UserName]
  fname = params[:FileName]
  a= []
  db = settings.mongo_db
  result = db[:mapping].find(:username => "#{uname}", :filename => "#{fname}").each do |document|
    return JSON.generate(document)
  end
end
#     a.push(document)
#   end
#   if a==[]
#     return "No functions listed"
#   else
#     return JSON.generate(a)
# end 
# end


 delete "/lambda/:UserName/:FileName" do
  filename=params[:FileName]
  uname=params[:UserName]
  db = settings.mongo_db
  db[:mapping].find(:username => "#{uname}",:filename =>"#{filename}").each do |document|
  db[:'fs.files'].delete_one(:_id => document[:_id])
  db[:'fs.chunks'].delete_one(:files_id => document[:_id])
  db[:mapping].delete_one(:_id => document[:_id] )
  return "Function Deleted!"
 end  
  
end

post "/lambda" do 
  req = Rack::Request.new(env)
  obj = JSON.parse(env['rack.input'].read)
  filename = obj["FileName"]
  username=obj["UserName"]
  eventtype=obj["EventType"]
  eventsource=obj["EventSource"]
  memory=obj["Memory"]
  environment=obj["Environment"]
  content_type :json
  db = settings.mongo_db
  n = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").count
  if (n > 0)
  	return "Duplicate Function. Please retry"  	
  else
    c = db[:'fs.files'].find(:metadata => "#{username}",:filename =>"#{filename}").count
    if (c == 0)
      return "No function found for this data. Please upload function first."
    else
      db[:'fs.files'].find(:metadata => "#{username}",:filename =>"#{filename}").each do |document|
        id = document[:_id]
      	result = db[:mapping].insert_one({"_id": id,
                                    	    "filename": filename,
                                    	    "username": username,
                                    	    "eventType": eventtype,
                                    	    "eventsource": eventsource,
                                    	    "memory": memory,
                                    	    "environment": environment,
    					                            "sequence_count":0})  	
      {:_id=>id, :filename=>filename, :username=>username, :eventType=>eventtype, :eventsource=>eventsource, :memory=>memory, 
            :environment=>environment}
      end
    end
  end
end

put "/lambda" do 
  req = Rack::Request.new(env)
  obj = JSON.parse(env['rack.input'].read)
  filename = obj["FileName"]
  username=obj["UserName"]
  eventtype=obj["EventType"]
  eventsource=obj["EventSource"]
  memory=obj["Memory"]
  environment=obj["Environment"]
  content_type :json
  db = settings.mongo_db
  n = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").count
  if (n > 0)
    if (eventtype != nil)
      doc = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").find_one_and_replace({'$set' => { :eventType =>"#{eventtype}"}}, :return_document => :after)     
    end
    if (eventsource != nil)
      doc = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").find_one_and_replace({'$set' => { :eventsource =>"#{eventsource}"}}, :return_document => :after)     
    end
    if (memory != nil)
      doc = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").find_one_and_replace({'$set' => { :memory =>"#{memory}"}}, :return_document => :after)     
    end
    if (environment != nil)
      doc = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").find_one_and_replace({'$set' => { :environment =>"#{environment}"}}, :return_document => :after)     
    end
    return doc.to_json
  end
end

# put "/lambda" do
#   filename = params[:data][:filename]
#   username=params[:UserName]
#   eventtype=params[:EventType]
#   eventsource=params[:EventSource]
#   memory=params[:Memory]
#   environment=params[:Environment]
#   content_type :json
#   db = settings.mongo_db
#   db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").each do |document|
#   db[:'fs.files'].delete_one(:_id => document[:_id])
#   db[:'fs.chunks'].delete_one(:files_id => document[:_id])
#   db[:mapping].delete_one(:_id => document[:_id] )
# end  
#     fs_bucket = db.database.fs(read: { mode: :secondary })
#     file = File.open(params['data'][:tempfile], "r")
#     id = fs_bucket.upload_from_stream(params['data'][:filename], file)
#     file.close
#     result = db[:mapping].insert_one({"_id":id,
#                                 	    "filename": filename,
#                                 	    "username": username,
#                                 	    "eventType": eventtype,
#                                 	    "eventsource": eventsource,
#                                 	    "memory": memory,
#                                 	    "environment": environment,
# 					                    "sequence_count":0})
#   {:_id=>id, :filename=>filename, :username=>username, :eventType=>eventtype, :eventsource=>eventsource, :memory=>memory, 
#   :environment=>environment}.to_json   
# end 

post "/lambda/fileupload" do
  filename = params[:data][:filename]
  username=params[:UserName]
  db = settings.mongo_db
  n = db[:'fs.files'].find(:metadata => "#{username}",:filename =>"#{filename}").count
  if (n > 0)
    return "Duplicate Function. Please retry"   
  else
    fs_bucket = db.database.fs(read: { mode: :secondary })
    file = File.open(params['data'][:tempfile], "r")
    fs_bucket.upload_from_stream(params['data'][:filename], file, :metadata => "#{username}")
    file.close
  end
end