require "rubygems"
require "rack"
Dir.glob("lib/**/*.rb").each { |x| $:.unshift(File.dirname(x)) }
require 'bootstrap_container'
require 'bootstrap_routing'
require 'log'

module Booty
  class Application
    def self.run
      Log.bind_to(ConsoleLogFactory.new)
      BootstrapContainer.new.run
      BootstrapRouting.new.run
      logger.debug("starting up http://localhost:9292")

      Rack::Handler::Mongrel.run IOC.resolve(:front_controller), :Port => 9292
    end
  end
end

Booty::Application.run
