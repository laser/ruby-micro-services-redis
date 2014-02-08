require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Basicsoa
  class Application < Rails::Application
    config.assets.initialize_on_precompile = false
    config.assets.enabled = false
  end
end
