$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require "action_controller/railtie"
require 'gaffe'

class ApplicationController < ActionController::Base
end
