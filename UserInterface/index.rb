require 'haml'
require 'zip'
require 'find'

require 'json/ext'

get "/index" do
  haml :index
end 
post "/index" do
  username=params[:UserName]
  redirect "/action?UserName=#{username}"
end

# Handle GET-request (Show the upload form)
get "/upload" do
  haml :upload
end 

 post "/upload" do 
  filename = params[:myfile][:filename]
  username=params[:UserName]
  eventtype=params[:EventType]
  eventsource=params[:EventSource]
  memory=params[:Memory]
  environment=params[:Environment]
  currentDir = Dir.pwd
  content_type :json
  db = settings.mongo_db
  n = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").count
  if (n > 0)
  	return "Duplicate Function. Please retry"  	
  else
  	fs_bucket = db.database.fs(read: { mode: :secondary })
  	file = File.open(params['myfile'][:tempfile], "r")
  	id = fs_bucket.upload_from_stream(params['myfile'][:filename], file)
  	file.close
  	result = db[:mapping].insert_one({"_id":id,
	    "filename": filename,
	    "username": username,
	    "eventType": eventtype,
	    "eventsource": eventsource,
	    "memory": memory,
	    "environment": environment})
  return "Data Saved"  	
  end  
end




# Handle GET-request (Show the upload form)
get "/action" do
  haml :action

end 

post "/action" do
  parm = params[:submit]
  username=params[:UserName]
  case parm
  when "Upload a Function!"
    redirect "/upload?UserName=#{username}"
  when "Delete a Function!"
    redirect "/delete?UserName=#{username}"
  when "List my Functions!"
    redirect "/list?UserName=#{username}"
  when "Update a Function!"
    redirect "/update?UserName=#{username}"
  end
end


get "/update" do
  haml :update
end 

post "/update" do
  filename=params[:FileName]
  uname=params[:UserName]
  db = settings.mongo_db
  n = db[:mapping].find(:username => "#{uname}",:filename =>"#{filename}").count
  if (n == 0)
    return "Invalid function name. Please try again."    
  else
    db[:mapping].find(:username => "#{uname}",:filename =>"#{filename}").each do |document|
    eventtype = document[:eventType]   
    eventsource = document[:eventsource]
    memory = document[:memory]
    redirect "/updateFunc?UserName=#{uname}&EventType=#{eventtype}&EventSource=#{eventsource}&Memory=#{memory}&FileName=#{filename}"
    end    
  end
end


# Handle POST-request (Receive and save the uploaded file)

get "/updateFunc" do
  haml :updateFunc
end 


post "/updateFunc" do
  filename = params[:myfile][:filename]
  fname = params[:FileName]
  username=params[:UserName]
  eventtype=params[:EventType]
  eventsource=params[:EventSource]
  memory=params[:Memory]
  environment=params[:Environment]
  content_type :json
  db = settings.mongo_db
  db[:mapping].find(:username => "#{username}",:filename =>"#{fname}").each do |document|
  db[:'fs.files'].delete_one(:_id => document[:_id])
  db[:'fs.chunks'].delete_one(:files_id => document[:_id])
  db[:mapping].delete_one(:_id => document[:_id] )
end  
  # n = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").count
  # if (n > 0)
  #   return "Duplicate Function. Please retry"   
  # else
    fs_bucket = db.database.fs(read: { mode: :secondary })
    file = File.open(params['myfile'][:tempfile], "r")
    id = fs_bucket.upload_from_stream(params['myfile'][:filename], file)
    file.close
    result = db[:mapping].insert_one({"_id":id,
      "filename": filename,
      "username": username,
      "eventType": eventtype,
      "eventsource": eventsource,
      "memory": memory,
      "environment": environment})
  return "Data Saved"   
  # end  
end 



get "/delete" do
  haml :delete
end 


post "/delete" do 
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


get "/list" do
uname=params[:UserName]
a= []
db = settings.mongo_db
result = db[:mapping].find(:username => "#{uname}").each do |document|
	a.push(document[:filename]+"     "+ "\n")
end
if a==[]
  return "No functions listed"
else
  return a
end
end