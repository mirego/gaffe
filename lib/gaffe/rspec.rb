RSpec.configure do |config|

  # Allow to write feature specs for dynamic error pages
  config.around :each, :with_error_pages, type: :feature do |example|
    begin
      # Ensure that rails will render error pages when an error occurs
      old, values = Rails.application.config.consider_all_requests_local, Rails.application.config.action_dispatch.show_exceptions
      Rails.application.config.consider_all_requests_local = false
      Rails.application.config.action_dispatch.show_exceptions = true
      example.call # Run the example
    ensure
      # Restore old values
      Rails.application.config.consider_all_requests_local = old
      Rails.application.config.action_dispatch.show_exceptions = values
    end
  end

end
