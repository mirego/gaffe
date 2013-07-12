require 'gaffe'
require 'rails'

module Gaffe
  class Railtie < Rails::Railtie
    initializer 'gaffe.errors_controller' do |app|
      ActiveSupport.on_load :action_controller do
        require 'gaffe/errors_controller'

        # Look for app/controllers/errors_controller.rb
        errors_controller_path = Rails.root.join('app', 'controllers', 'errors_controller.rb')
        require errors_controller_path if File.exists? errors_controller_path

        app.config.exceptions_app = lambda do |env|
          controller = defined?(::ErrorsController) ? ::ErrorsController : Gaffe::ErrorsController
          controller.action(:show).call(env)
        end
      end
    end
  end
end
