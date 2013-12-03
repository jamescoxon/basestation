#!/usr/bin/env ruby

# Inspired by http://www.george-smart.co.uk/wiki/APRS_with_the_FUNcube_Dongle
# Requires QTMM to be running but via the command line e.g:
# $ /Applications/AFSK1200\ Decoder.app/Contents/MacOS/AFSK1200\ Decoder > raw.txt
# Once the server is running you'll need to open Xastir
# Setup Xastir to use an Internet Server and direct it to server you are running
# this aprs.rb script


require 'socket'	# Get sockets from stdlib
require 'file/tail'	# http://flori.github.io/file-tail/		

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
