require 'rubygems'
require 'dnssd'
require 'ruby-osc'

include  OSC

puts

zeroconf_registrar = fork {
  registrar = DNSSD::Service.new
  registrar.register 'sam', '_osc._udp', nil, 9090, do |r|
    puts "registered #{r.fullname}"
  end
}
Process.detach(zeroconf_registrar)

zeroconf_browser = fork {
  browser = DNSSD::Service.new
  services = {}

  puts
  puts "Browsing for open sound control UDP services"

  browser.browse '_osc._udp' do |reply|
    services[reply.fullname] = reply
    next if reply.flags.more_coming?

    services.sort_by do |_, service|
      [(service.flags.add? ? 0 : 1), service.fullname]
    end.each do |_, service|
      add = service.flags.add? ? 'Add' : 'Remove'
      puts "#{add} #{service.name} on #{service.domain}"
    end

    services.clear

    puts
  end
}
Process.detach(zeroconf_browser)

server = Server.new 9090

server.add_pattern /.*/ do |*args|       # this will match any address
  p "/.*/:       #{ args.join(', ') }"
end

server.add_pattern "/exit" do |*args|    # this will just match /exit address
  exit
end

OSC::Thread.join