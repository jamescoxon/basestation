#!/usr/bin/env ruby

require 'socket'               # Get sockets from stdlib
require 'file/tail'

filename = "/Applications/AFSK1200\ Decoder.app/Contents/MacOS/raw.txt"

server = TCPServer.open(14580)  # Socket to listen on port 14580
puts "Opened Server"

loop {                         # Servers run forever
  	client = server.accept       # Wait for a client to connect
	File::Tail::Logfile.open(filename) do |log|
    		log.backward(2).tail { |line|
		data = line.split("}")
		if data[1].nil?
			#do nothing
		elsif data[1].include?(">")
			client.puts(data[1])
		end
	}
  end
  client.close                 # Disconnect from the client
}
