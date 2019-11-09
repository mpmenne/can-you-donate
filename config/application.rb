# frozen_string_literal: true

require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
Bundler.require(*Rails.groups)
module Avala
  class Application < Rails::Application
    config.assets.quiet = true
    config.generators do |generate|
      generate.helper false
      generate.javascripts false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.action_controller.default_protect_from_forgery = false
    config.load_defaults 5.2
    config.generators.system_tests = nil
    config.eager_load_paths << Rails.root.join('lib')
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/v1/*', headers: :any, methods: %i[get post options]
      end
    end
  end
end
