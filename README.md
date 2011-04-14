zosc
====
A work in progress that comes with no warranty, MIT licensed

DESCRIPTION
---------------------
A "one to all" style open sound control router using zeroconf DNS service discovery (aka Bonjour, MDNS)

SYNOPSIS
----------------
Registers on port 9092 as a zeroconf _osc._udp service

Messages received on port 9090 are routed via unicast to other instances of the software on the network via port 9092
Messages received on port 9090 are routed to localhost port 9091
Messages received on port 9092 from the network are routed to localhost port 9091

See the Max MSP 5 example patcher for a demo.

REQUIREMENTS
--------------------------
This should be cross platform because of the ruby gems used but the dnssd gem cannot currently be built for windows https://github.com/tenderlove/dnssd/issues#issue/4

Untested on everything but OS X 10.6
Ruby 1.9.1+ or JRuby
dnssd gem https://github.com/tenderlove/dnssd
ruby-osc gem https://github.com/maca/ruby-osc

OS X INSTALL 
---------------------
OS X Developer tools must be installed http://developer.apple.com/xcode/

A local copy of git installed to clone the project, I use and recommend Homebrew http://github.com/mxcl/homebrew for dependency installation

	brew install git

Ruby 1.9.1+ or JRuby is needed for the gems used and I recommend latest stable release (see http://www.ruby-lang.org/en/downloads/ )
OS X 10.6 comes with Ruby 1.8.7 pre installed and we can manage multiple installs of ruby with RVM

        sudo gem update --system #the version of rubygems that comes with 10.6 is a bit outdated so update it
        sudo gem install rvm  #follow on screen instructions to add it to your ~/.bash_profile
        
        #new terminal window
        rvm install 1.9.2 #latest at time of writing
        rvm use 1.9.2 #do this for each terminal window you want to run a different version of ruby in
        ruby -v #check current ruby version
        sudo gem install dnssd
        sudo gem install ruby-osc
        git clone git://github.com/samBiotic/zosc.git
        cd zosc
        ruby zosc.rb #eventmachine may say it isn't initialised, if so wait a few seconds and try it again ($ !!)

USAGE
-----------	
* Send any osc message or bundle to all zosc instances on the network via localhost on port 9090 and receive from all zosc instances on port 9091
* Quit zosc with /exit message sent to localhost 9090
* Enjoy!