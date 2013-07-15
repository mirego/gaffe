$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require "action_controller/railtie"
require 'gaffe'

RSpec.configure do |config|
  config.before(:each) do
    Rails.stub(:root).and_return(RAILS_ROOT)
  end
end

# We need a fake "ApplicationController" because Gaffe's default controller inherits from it
class ApplicationController < ActionController::Base
end

# We need Rails.root
RAILS_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
