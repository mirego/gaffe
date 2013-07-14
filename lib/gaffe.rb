require 'gaffe/version'
require 'gaffe/errors'

module Gaffe
  # Yield a block to populate @configuration
  def self.configure
    yield configuration
  end

  # Return the configuration settings
  def self.configuration
    @configuration ||= OpenStruct.new
  end

  # Return either the user-defined controller or our default controller
  def self.errors_controller
    @errors_controller ||= (configuration.errors_controller || builtin_errors_controller)
  end

  # Return our default controller
  def self.builtin_errors_controller
    require 'gaffe/errors_controller'
    Gaffe::ErrorsController
  end

  # Configure Rails to use our code when encountering exceptions
  def self.enable!
    Rails.application.config.exceptions_app = lambda do |env|
      Gaffe.errors_controller.action(:show).call(env)
    end
  end
end
