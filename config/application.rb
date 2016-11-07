require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VampART
  class Application < Rails::Application
    config.autoload_paths += ["#{config.root}/lib", "#{config.root}/app/services"]

    Dir[Rails.root.join('lib/*.rb')].each do |lib|
      require lib
    end
  end
end
