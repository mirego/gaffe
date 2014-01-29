$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'action_controller/railtie'
require 'gaffe'

RSpec.configure do |config|
  config.before(:each) do
    # Fake Rails.root
    Rails.stub(:root).and_return(RAILS_ROOT)

    # Fake Rails.application
    Rails.stub(:application).and_return OpenStruct.new(config: OpenStruct.new, env_config: {})

    # Make sure we clear memoized variables before each test
    [:@configuration].each do |variable|
      Gaffe.send :remove_instance_variable, variable if Gaffe.instance_variable_defined?(variable)
    end
  end
end

# We need a fake "ApplicationController" because Gaffe's default controller inherits from it
class ApplicationController < ActionController::Base
end

# We need Rails.root
RAILS_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
