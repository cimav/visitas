require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Visitas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = 'Chihuahua'
    config.i18n.default_locale = :es

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_job.queue_adapter = :sidekiq

    # Email Configuration
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address   => "smtp.gmail.com",
        :port      => 587,
        :domain    => "cimav.edu.mx",
        :authentication => :plain,
        :user_name      => "notificaciones@cimav.edu.mx",
        :password       => "N0t1f1c4c10n35@C1m4v!",
        :enable_starttls_auto => true
    }

    config.action_mailer.asset_host = "https://visitas.cimav.edu.mx"

  end
end
