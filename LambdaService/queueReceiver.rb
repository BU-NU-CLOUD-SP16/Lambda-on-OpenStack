#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:automatically_recover => false)
conn.start

channel   = conn.create_channel
queue    = channel.queue("lambda Queue")

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  queue.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end