require 'gaffe/version'

require 'ostruct'
require 'pathname'
require 'gaffe/errors'
require 'gaffe/errors_controller_resolver'

module Gaffe
  # Yield a block to populate @configuration
  def self.configure
    yield configuration
  end

  # Return the configuration settings
  def self.configuration
    @configuration ||= OpenStruct.new
  end

  # Configure Rails to use our code when encountering exceptions
  def self.enable!
    Rails.application.config.exceptions_app = lambda do |env|
      Gaffe.errors_controller_for_request(env).action(:show).call(env)
    end
  end

  # Return the right errors controller to use for the request that
  # triggered the error
  def self.errors_controller_for_request(env)
    resolver = ErrorsControllerResolver.new(env)
    resolver.resolved_controller
  end

  # Return the root path of the gem
  def self.root
    Pathname.new(File.expand_path('../../', __FILE__))
  end
end
