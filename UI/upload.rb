require 'sinatra'
require 'haml'
require 'zip'
require 'find'

# Handle GET-request (Show the upload form)
get "/upload" do
  haml :upload
end 

# Handle POST-request (Receive and save the uploaded file)
post "/upload" do 
	filename=params[:FileName]
	username=params[:UserName]
	eventtype=params[:EventType]
	eventsource=params[:EventSource]
	memory=params[:Memory]
	environment=params[:Environment]
    File.open('uploads/' + params['myfile'][:filename], "wb") do |f|
   	 f.write(params['myfile'][:tempfile].read)
   	out_file = File.new('uploads/'+"#{username}_#{filename}.csv", "w")
    out_file.puts ("#{username},#{eventtype},#{eventsource},#{memory},#{environment}")
    out_file.close
  end
 return "The file was successfully uploaded!"
end

get "/delete" do
  haml :delete
end 

# Handle POST-request (Receive and save the uploaded file)
post "/delete" do 
  filename=params[:FileName]
  username=params[:UserName]
    File.delete('uploads/'+"#{username}_#{filename}.csv")
    File.delete('uploads/'+"#{filename}.zip")
    return "File deleted successfully"
end


get "/list" do
  haml :list
end 

post "/list" do
functionlist = []
Find.find('uploads/') do |item|
  functionlist << item if item =~ /.*\.pdf$/   #username????.zip
end
return functionlist
end
