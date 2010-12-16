require 'rubygems'
require 'dnssd'
require 'ruby-osc'

include  OSC

puts "What is your name?"

$name = gets.chomp
$forwarding_port = 9090
$local_out_port = 9091
$rx_port = 9092
$clients = Array.new
local_out_client = Client.new $local_out_port
forwarding_server = Server.new $forwarding_port
rx_server = Server.new $rx_port

zeroconf_registrar = Thread.new() {
  registrar = DNSSD::Service.new
  registrar.register $name, '_osc._udp', nil, $rx_port, do |r|
  end
}
    
zeroconf_browse_and_resolve = Thread.new() {
  browser = DNSSD::Service.new
  services = {}

  browser.browse '_osc._udp' do |reply|
    services[reply.fullname] = reply
    next if reply.flags.more_coming?

    services.sort_by do |_, service|
      [(service.flags.add? ? 0 : 1), service.fullname]
    end.each do |_, service|
      if service.name != $name then
        add = service.flags.add? ? 'Add' : 'Remove'
        puts "#{add} #{service.name}"
        if add == 'Remove' then
          $clients.delete_at($clients.index($clients.detect{|aa| aa.include?(service.name)}))
        end
        next unless service.flags.add?
     
        resolver = DNSSD::Service.new
        resolver.resolve service do |r|
          puts "-> #{r.target}:#{r.port}"
          client = Client.new r.port, r.target
          $clients << [r.name, client]
          break unless r.flags.more_coming?
        end
        resolver.stop
      end      
    end
    services.clear
  end
}

forwarding_server.add_pattern "/exit" do |*args|    # this will just match /exit address
  forwarding_server.stop
  rx_server.stop
  exit
end

forwarding_server.add_pattern /.*/ do |*args|       # this will match any address
  puts "#{ args.join(', ') }"
  local_out_client.send Message.new(args[0], *args[1..-1])
  $clients.length.times do |i|
    $clients[i][1].send Message.new(args[0], *args[1..-1])
  end
end

rx_server.add_pattern /.*/ do |*args|       # this will match any address
  puts "#{ args.join(', ') }"
  local_out_client.send Message.new(args[0], *args[1..-1])
end

OSC::Thread.join