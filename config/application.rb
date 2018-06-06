require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SaintLBeauApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.action_dispatch.default_headers['P3P'] = 'CP="Not used"'
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }
    config.action_dispatch.default_headers = {
        'X-XSS-Protection' => '0;'
    }


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
