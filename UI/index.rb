require 'haml'
require 'zip'
require 'find'

get "/index" do
  haml :index
end 

post "/index" do
    redirect '/action',303
end

# Handle GET-request (Show the upload form)
get "/upload" do
  haml :upload
end 

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

# Handle GET-request (Show the upload form)
get "/action" do
  haml :action

end 

post "/action" do
  parm = params[:submit]
  case parm
  when "Upload a Function!"
      redirect '/upload'
  when "Delete a Function!"
      redirect '/delete'
  when "List my Functions!"
  functionlist = []
    a = []
    Dir.glob('uploads/'"**/*.zip").each do |item| 
     a.push(item.split("/")[1]+ "    ")
    end
return a
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
    File.delete('uploads/'+"#{username}_#{filename}.csv")
    File.delete('uploads/'+"#{filename}.zip")
    return "File deleted successfully"
end


get "/list" do
  haml :list
end 

post "/list" do
functionlist = []
#Find.find('uploads/') do |item|
#  functionlist << item if item =~ /.*\.pdf$/   #username????.zip
a = []
Dir.glob('uploads/'"**/*.zip").each do |item| 
  a.push(item.split("/")[1]+ "    ")
end
return a
end

