require 'gaffe/version'

module Gaffe
end

require 'gaffe/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
