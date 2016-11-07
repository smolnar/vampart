require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VampART
  class Application < Rails::Application
    config.autoload_paths += ["#{config.root}/lib", "#{config.root}/app/services"]
  end
end

require 'data_repository'
require 'basic_logger'
require 'data_repository'
require 'nasjonalmuseet'
require 'simple_threaded_downloader'
require 'webumenia'
