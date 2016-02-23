require 'haml'
require 'zip'
require 'find'

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
  fname=filename.split(".")[0]
  username=params[:UserName]
  eventtype=params[:EventType]
  eventsource=params[:EventSource]
  memory=params[:Memory]
  environment=params[:Environment]
  currentDir = Dir.pwd
  if Dir.exist?("uploads/#{username}")
      Dir.chdir("uploads/#{username}")    
  else
      Dir.mkdir("uploads/#{username}")
      Dir.chdir("uploads/#{username}") 
  end
  File.open(params['myfile'][:filename], "wb") do |f|
    f.write(params['myfile'][:tempfile].read)
    end
  out_file = File.new("#{username}_#{fname}.csv", "w")
  out_file.puts ("#{username},#{eventtype},#{eventsource},#{memory},#{environment}")
  out_file.close
  Dir.chdir("#{currentDir}")  
 return "The file has been uploaded and data has been saved successfully!"
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
  end
end


# Handle POST-request (Receive and save the uploaded file)


get "/delete" do
  haml :delete
end 

# Handle POST-request (Receive and save the uploaded file)
post "/delete" do 
  filename=params[:FileName]
  username=params[:UserName]
  currentDir= Dir.pwd
   if Dir.exist?("uploads/#{username}")
    Dir.chdir("uploads/#{username}")
   else
     return Dir.pwd        
  end 
    File.delete("#{username}_#{filename}.csv")
    File.delete("#{filename}.py")
    Dir.chdir("#{currentDir}")
    return "File deleted successfully"
  end

get "/list" do
	username=params[:UserName]
    a = []
    if Dir.exist?("uploads/#{username}")
      Dir.glob("uploads/#{username}/""**/*.py").each do |item| 
        a.push(item.split("/")[2]+ "    ")
      end
    else
      return "You do not have any functions!"    
    end
  return a
end