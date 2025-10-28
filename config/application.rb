require_relative "boot"

require "rails/all"
require "devise"

Bundler.require(*Rails.groups)

module TrainingRuby
  class Application < Rails::Application
    config.load_defaults 8.0
    config.active_job.queue_adapter = :async
    config.autoload_paths << Rails.root.join("lib")
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash
    config.api_only = false

    config.middleware.use Rack::Cors do
      allow do
        origins "localhost:3000", "127.0.0.1:3000", "your-production-domain.com"
        resource "*",
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head], # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
          expose: [ "Authorization" ],
          max_age: 600
      end
    end
    config.autoload_lib(ignore: %w[assets tasks])
    # config.active_job.queue_adapter = :sidekiq
  end
end
