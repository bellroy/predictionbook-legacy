# Overridden when deployed by capistrano with deploy:set_deliverer_hostname
#Deliverer.default_url_options[:host] = 'localhost:3000'
ActionMailer::Base.default_url_options = 'localhost:3000'
