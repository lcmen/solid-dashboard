require_relative "boot"

require "rails/all"
if ENV["ASSET_PIPELINE"] == "sprockets"
  require "sprockets/railtie"
else
  require "propshaft"
end

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    config.action_controller.include_all_helpers = false
    config.active_job.queue_adapter = :solid_queue
    config.solid_queue.connects_to = {database: {writing: :primary}}

    config.autoload_lib(ignore: %w[assets tasks])
  end
end
