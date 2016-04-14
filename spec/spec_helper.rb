$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'action_controller/railtie'
require 'gaffe'
require_relative './application_controller_helper'
require 'gaffe/errors_controller'

RSpec.configure do |config|
  # Disable `should` syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # Fake Rails.root
    allow(Rails).to receive(:root).and_return(RAILS_ROOT)

    # Fake Rails.application
    application = double('Rails Application', config: OpenStruct.new, env_config: {})
    allow(Rails).to receive(:application).and_return(application)

    # Make sure we clear memoized variables before each test
    [:@configuration].each do |variable|
      Gaffe.send :remove_instance_variable, variable if Gaffe.instance_variable_defined?(variable)
    end
  end
end

def test_request
  if Rails::VERSION::MAJOR >= 5
    ActionDispatch::TestRequest.create
  else
    ActionDispatch::TestRequest.new
  end
end

# We need Rails.root
RAILS_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
