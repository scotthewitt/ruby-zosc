require 'rubygems'
require 'dnssd'
require 'ruby-osc'

include  OSC

zeroconf_registrar = Thread.new() {
  registrar = DNSSD::Service.new
  registrar.register 'sam', '_osc._udp', nil, 9090, do |r|
    puts "registered #{r.fullname}"
  end
}

zeroconf_loop = Thread.new() {
  while (1)
    zeroconf_browse_and_resolve = Thread.new() {
      browser = DNSSD::Service.new
      services = {}

      browser.browse '_osc._udp' do |reply|
        services[reply.fullname] = reply
        next if reply.flags.more_coming?

        services.sort_by do |_, service|
          [(service.flags.add? ? 0 : 1), service.fullname]
        end.each do |_, service|
          next unless service.flags.add?

          resolver = DNSSD::Service.new
          resolver.resolve service do |r|
            puts "#{r.name} on #{r.target}:#{r.port}"
            break unless r.flags.more_coming?
          end

          resolver.stop
        end

        services.clear
      end
    }
    sleep(5)
  end
}

server = Server.new 9090

server.add_pattern /.*/ do |*args|       # this will match any address
  puts "/.*/:       #{ args.join(', ') }"
end

server.add_pattern "/exit" do |*args|    # this will just match /exit address
  server.stop
  exit
end

OSC::Thread.join