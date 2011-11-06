Predictionbook::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = true
  config.action_controller.cache_store = :file_store, "cache/fragments"

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' } 
end

# Passenger remote debug connection
# usage:
# $ touch tmp/restart.txt tmp/debug.txt
# … start request in browser
# $ rdebug -c
if File.exists?(File.join(Rails.root,'tmp', 'debug.txt'))
  require 'ruby-debug'
  Debugger.wait_connection = true
  Debugger.start_remote
  debugger # get rdebug console so you can set breakpoints
  File.delete(File.join(Rails.root,'tmp', 'debug.txt'))
end
