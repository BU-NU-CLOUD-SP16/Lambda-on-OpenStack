
require "./../Queueing/EventDispatcher"
require "json"

class EventOrchestrator

	def begin_queing(args, *varargs)
		payload= create_payload(args, varargs)
		eventSender = EventDispatcher.new()
		eventSender.send_event(payload)
	end

	def create_payload(args, *varargs)
		data = {}
		varargs.each do |item|
			data = data.merge!({"item" => "item"})
		end
		p = '{ 
			    "event_data":{ "type":"FileCreate", "metadata_type":"filename", "filename":"test.txt" }, 
			    "user_name":"naomi", 
			    "event_source":"S1"}'
		data  = JSON.parse(p)
		payload = data.to_s()
		payload
		# {"eventName" => args, "data"=> data}
	end
end



