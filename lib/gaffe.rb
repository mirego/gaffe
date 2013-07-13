require 'gaffe/version'
require 'gaffe/errors'

module Gaffe
  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= OpenStruct.new
  end

  def self.errors_controller
    @errors_controller ||= (configuration.errors_controller || builtin_errors_controller)
  end

  def self.builtin_errors_controller
    require 'gaffe/errors_controller'
    Gaffe::ErrorsController
  end

  def self.enable!
    Rails.application.config.exceptions_app = lambda do |env|
      Gaffe.errors_controller.action(:show).call(env)
    end
  end
end
