
require "./../Queueing/EventDispatcher"

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
		payload = "new payload"  
		# {"eventName" => args, "data"=> data}
	end
end