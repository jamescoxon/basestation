# 0 = 15
# 10 = 31
# 20 = 44
# 30 = 58
# 40 = 69
# eq = f(x) = 1.35x + 16.4

require 'serialport'
require 'json'
require 'curb'
require 'crack'

port_str="/dev/tty.usbmodem1a21"
baud_rate=9600
data_bits=8
stop_bits=1
parity=SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

sleep(1)

puts sp.readline(4)

c = Curl::Easy.http_get('http://habitat.habhub.org/habitat/_design/flight/_view/launch_time_including_payloads?include_docs=True&descending=True&limit=10')

puts c.body_str

data = Crack::JSON.parse(c.body_str)

puts "Select flight to track:"
#puts data['rows'][0]['id']
puts "(0)"
puts data['rows'][0]['doc']['name']
#puts data['rows'][0]['value']['_id']

#puts data['rows'][1]['id']
puts "(1)"
puts data['rows'][1]['doc']['name']
#puts data['rows'][1]['value']['_id']

#puts data['rows'][2]['id']
puts "(2)"
puts data['rows'][2]['doc']['name']
#puts data['rows'][2]['value']['_id']

#puts data['rows'][3]['id']
puts "(3)"
puts data['rows'][3]['doc']['name']
#puts data['rows'][3]['value']['_id']

#puts data['rows'][4]['id']
puts "(4)"
puts data['rows'][4]['doc']['name']
#puts data['rows'][4]['value']['_id']

payload_select = gets.to_i

payload_id = data['rows'][payload_select]['id']
payload_key = data['rows'][payload_select]['value']['_id']

url = 'http://habitat.habhub.org/habitat/_design/ept/_list/json/payload_telemetry/flight_payload_time?include_docs=true&startkey=["%s,%s"]&fields=altitude&descending=True&limit=1' % [payload_id, payload_key]
puts url

loop do
	d = Curl::Easy.http_get(url)

	split_d = d.body_str.split(': ')

	altitude = (split_d[1].chop.chop.chop.chop).to_i

	puts altitude

	i = (1.45 * (altitude / 1000)) + 16.5
	sp.putc(i)
	puts 'Wrote: %d = %bb which is %d' % [ i, i, altitude ]

	sleep(30)
end

sp.close
