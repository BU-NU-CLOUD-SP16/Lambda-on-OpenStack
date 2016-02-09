require "rubygems"
require "bunny"

class EventDispatcher
	
	@@conn = Bunny.new(:automatically_recover => false)	
	
	def send_event(payload)
		@@conn.start
		channel   = @@conn.create_channel
		queue    = channel.queue("lambda Queue")

		channel.default_exchange.publish(payload, :routing_key => queue.name)
		puts " [x] Sent " + " " + payload 

		@@conn.close
	end
end


