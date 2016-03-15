require 'pathname'
require 'socket'

require 'pry'
require 'denv'
Denv.load

require 'pushbullet'
Pushbullet.api_token = ENV['PUSHBULLET_TOKEN']

private_ip_cache_path = Pathname.new('/tmp/private_ip_cache')
private_ip = Socket.ip_address_list.select {|e| e.ipv4_private? }.first
raise "Can not get private ip" unless private_ip
private_ip = private_ip.ip_address

if !private_ip_cache_path.exist? || private_ip_cache_path.read.chomp != private_ip
  Pushbullet::Contact.me.push_note('private ip changed', private_ip)
  private_ip_cache_path.write(private_ip)
else
  puts 'Nothing to do'
end
