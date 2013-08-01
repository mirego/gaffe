require 'gaffe/version'

require 'ostruct'
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

  # Return our default controller
  def self.builtin_errors_controller
    require 'gaffe/errors_controller'
    Gaffe::ErrorsController
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
    controller = configuration.errors_controller

    if controller.is_a?(Hash)
      controller = controller.detect { |pattern, _| env["REQUEST_URI"] =~ pattern }.try(:last)
    end

    controller || builtin_errors_controller
  end

  # Return the root path of the gem
  def self.root
    File.expand_path('../../', __FILE__)
  end
end
