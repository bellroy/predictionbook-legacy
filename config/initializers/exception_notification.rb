address = "errors@example.com"
ExceptionNotifier.exception_recipients = address
ExceptionNotifier.sender_address = %("pbook" <#{address}>)
ExceptionNotifier.email_prefix = "[PBOOK-#{RAILS_ENV}-#{`hostname`.strip}] "

require 'application'
ApplicationController.send(:include, ExceptionNotifiable)
