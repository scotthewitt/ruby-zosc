require 'rubygems'
require 'dnssd'
require 'ruby-osc'

include  OSC

puts "What is your name?"
$name = gets.chomp
$port = 9090
server = Server.new $port

zeroconf_registrar = Thread.new() {
  registrar = DNSSD::Service.new
  registrar.register $name, '_osc._udp', nil, $port, do |r|
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
      add = service.flags.add? ? 'Add' : 'Remove'
      puts "#{add} #{service.name} on #{service.domain}"
      next unless service.flags.add?

      resolver = DNSSD::Service.new
      resolver.resolve service do |r|
        puts "#{r.name} on #{r.target}:#{r.port}"
        puts "\t#{r.text_record.inspect}" unless r.text_record.empty?
        break unless r.flags.more_coming?
      end

      resolver.stop
    end

    services.clear
  end
}

server.add_pattern /.*/ do |*args|       # this will match any address
  puts "/.*/:       #{ args.join(', ') }"
end

server.add_pattern "/exit" do |*args|    # this will just match /exit address
  server.stop
  exit
end

OSC::Thread.join