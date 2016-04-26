
require "./../Queueing/EventDispatcher"
require "json"

class EventOrchestrator

	def begin_queing(args, *varargs)
		payload= create_payload(args, varargs)
		eventSender = EventDispatcher.new()
		#eventSender.send_event(payload)
		data = {}
		p = '{
                            "event_data":{ "type":"FilexxxxCreate", "metadata_type":"filename", "filename":"test.py"},
                            "user_name":"testUser",
                            "event_source":"S1"}'
                data  = JSON.parse(p)
                payload1 = data.to_s()
                payload1
		eventSender.send_event(payload1)
	end

	def create_payload(args, varargs)
		data = {}
		varargs.each do |item|
			data = data.merge!({"item" => "item"})
		end
		p = '{ 
			    "event_data":{ "type":"FileCreate", "metadata_type":"filename", "filename":"sum.py"}, 
			    "user_name":"ashrith", 
			    "event_source":"S1"}'
		data  = JSON.parse(p)
		payload = data.to_s()
		payload
		# {"eventName" => args, "data"=> data}
	end
end



