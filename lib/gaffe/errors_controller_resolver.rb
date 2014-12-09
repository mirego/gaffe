module Gaffe
  class ErrorsControllerResolver
    # Accessors
    attr_reader :controller

    # Constants
    BUILTIN_CONTROLLER = lambda do
      require 'gaffe/errors_controller'
      Gaffe::ErrorsController
    end

    def initialize(env)
      @env = env
    end

    def resolved_controller
      # Use the configured controller first
      controller = Gaffe.configuration.errors_controller

      # Parse the request if multiple controllers are configured
      controller = request_controller(controller) if controller.is_a?(Hash)

      # Fall back on the builtin errors controller
      controller ||= BUILTIN_CONTROLLER.call

      # Make sure we return a Class
      controller.respond_to?(:constantize) ? controller.constantize : controller
    end

  private

    def request_controller(controllers)
      controllers.find { |pattern, _| @env['REQUEST_URI'] =~ pattern }.try(:last)
    end
  end
end
