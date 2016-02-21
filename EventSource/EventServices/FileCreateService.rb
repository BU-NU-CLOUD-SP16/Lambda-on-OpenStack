require "./EventFire"
require "Date"


class FileCreateService < Event

	@@defaultLocation = ""

	def initialize()
		@defaultLocation = Dir.pwd
	end

	def create_file(name, location)
		if location.length == 0
			location = @defaultLocation
		end
		newFile = File.open(location+"/"+name, "w")
		d = Date.parse(Time.now.to_s)
		time = (d >> 1).strftime("%d/%m/%Y %H:%M")
		newFile.write("This file is newly created at " +  time)	
		create_file_event(name)
	end

# Include the create service event type.
	def create_file_event(name)
		create_event(name)
	end
end

s = FileCreateService.new()

s.create_file("test.txt", "")