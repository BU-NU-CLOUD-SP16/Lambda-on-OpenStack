require 'haml'
require 'zip'
require 'find'

require 'json/ext'
#require 'helper/FileDownloader'

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
  filename = params[:data][:filename]
  fname = params[:FileName]
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
  # n = db[:mapping].find(:username => "#{username}",:filename =>"#{filename}").count
  # if (n > 0)
  #   return "Duplicate Function. Please retry"   
  # else
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
      "environment": environment})
  {:_id=>id, :filename=>filename, :username=>username, :eventType=>eventtype, :eventsource=>eventsource, :memory=>memory, 
  :environment=>environment}.to_json  
  # end  
end 

get "/logs/:username/:sequence_count" do
	puts "In log method"
	db= settings.mongo_db
	#puts "username "+params[:username]
	#puts "sequence_count "+params[:sequence_count]
	db[:mapping].find(:username => params[:username],:sequence_count => params[:sequence_count].to_i).each do |record|
		#puts "record: "+record
		if record
			log_file = "#{record[:filename]}"+"_"+"#{record[:log_uuid]}"+".log"
			puts "log file name: "+log_file
			#check_and_send_file(log_file)
			if File.exist?("../LambdaService/EventListener/#{log_file}")
				send_file "../LambdaService/EventListener/#{log_file}", :disposition => 'attachment', :filename =>"#{log_file}"
			else
				return "No log file for this specific sequence"
			end
		else
			return "No record for this sequence"
		end
	end
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
