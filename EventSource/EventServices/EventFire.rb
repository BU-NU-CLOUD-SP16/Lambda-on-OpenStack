require "./../EventOrchestrator/EventOrchestrator"

# This is the parent event class. This acts a communication channel between orchestrator and eventServices.
class Event
	def create_event(args, *varargs)
		orchestrator = EventOrchestrator.new()
		orchestrator.begin_queing(args, varargs)
	end
end