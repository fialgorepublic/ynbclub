require_relative 'boot'

require 'rails/all'
require "google/cloud/translate"
require "active_storage/engine"

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
    config.active_job.queue_adapter = :sidekiq

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.secret_key_base = "f99d5c6ceadd66e53177b0955c7d6a03104000d8d50dc170ce465ed9e0cd4c2aec44cbb72da02ebe1edd1bc1400874470ef1744e3b40171ec44aa1dab928369b"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
