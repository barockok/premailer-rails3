require 'action_mailer'
require 'premailer-rails3'
require 'premailer-rails3/action_mailer_extension'
module PremailerRails
  class Railtie < Rails::Railtie
    initializer "premailer_rails.extend_action_mailer" do
      ActiveSupport.on_load(:action_mailer) do
        include PremailerRails::ActionMailerExtension
      end
    end
  end
end
