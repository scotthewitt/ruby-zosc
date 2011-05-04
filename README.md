zosc
========================
A work in progress that comes with no warranty, MIT licensed

DESCRIPTION
------------------------
A "one to all" style open sound control router using zeroconf DNS service discovery (aka Bonjour, MDNS)

SYNOPSIS
------------------------
Registers on port 9092 as a zeroconf _osc._udp service

Messages received on port 9090 are routed via unicast to other instances of the software on the network via port 9092
Messages received on port 9090 are routed to localhost port 9091
Messages received on port 9092 from the network are routed to localhost port 9091

REQUIREMENTS
------------------------
* Ruby 1.9.1+ or JRuby
* [dnssd gem](https://github.com/tenderlove/dnssd)  this [cannot currently be built for windows](https://github.com/tenderlove/dnssd/issues#issue/4)
* [ruby-osc gem](https://github.com/maca/ruby-osc)

OS X INSTALL 
------------------------
[OS X developer tools](http://developer.apple.com/xcode/) must be installed 

A local copy of git installed to clone the project, I use and recommend [Homebrew](http://github.com/mxcl/homebrew/) for dependency installation

    brew install git

OS X 10.6 comes with Ruby 1.8.7 pre installed and we can manage multiple installs of ruby with RVM

    sudo gem update --system #the version of rubygems that comes with 10.6 is a bit outdated so update it
    sudo gem install rvm  #follow on screen instructions to add it to your ~/.profile
    
    #new terminal window
    rvm install 1.9.2 #latest at time of writing
    rvm use 1.9.2
    rvm --default use 1.9.2
    ruby -v #check current ruby version
    sudo gem install dnssd ruby-osc
    git clone git://github.com/samBiotic/ruby-zosc.git
    cd ruby-zosc
    

UBUNTU INSTALL 
------------------------

    sudo apt-get install build-essential git-core curl avahi-daemon avahi-utils libavahi-compat-libdnssd1 libavahi-compat-libdnssd-dev
    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc 
    . ~/.bashrc
    rvm install 1.9.2 #latest at time of writing
    rvm use 1.9.2
    rvm --default use 1.9.2
    ruby -v #check current ruby version
    gem install dnssd ruby-osc
    git clone git://github.com/samBiotic/ruby-zosc.git
    cd ruby-zosc

USAGE
------------------------

    ruby zosc.rb 
    !! #eventmachine may say it isn't initialised on first run, if so wait a few seconds and try it again

* Send any osc message or bundle to all zosc instances on the network via localhost on port 9090 and receive from all zosc instances on port 9091
* Quit zosc with /exit message sent to localhost 9090
* See the Max MSP 5 example patcher for a demo.
* Enjoy!

The MIT License
------------------------
Copyright (c) 2011 Sam Birkhead

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
