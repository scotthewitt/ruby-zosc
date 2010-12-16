require 'rubygems'
require 'dnssd'
require 'ruby-osc'

include  OSC

puts "What is your name?"

$name = gets.chomp
$rx_port = 9090
$tx_port = 9091
$clients = Array.new
client = Client.new $tx_port
$clients << client
server = Server.new $rx_port


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
        next unless service.flags.add?
     
        resolver = DNSSD::Service.new
        resolver.resolve service do |r|
          puts "-> #{r.target}:#{r.port}"
          client = Client.new r.port, r.target
          $clients << client
          break unless r.flags.more_coming?
        end
        resolver.stop
      end      
    end
    services.clear
  end
}

server.add_pattern /.*/ do |*args|       # this will match any address
  puts "/.*/:       #{ args.join(', ') }"
  $clients.length.times do |i|
    $clients[i].send Message.new(args[0], *args[1..-1])
  end
end

server.add_pattern "/exit" do |*args|    # this will just match /exit address
  server.stop
  exit
end

OSC::Thread.join