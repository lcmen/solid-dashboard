require "rails"
require "rails/engine"

module SolidDashboard
  class Engine < ::Rails::Engine
    isolate_namespace SolidDashboard

    initializer "solid_dashboard.assets" do |app|
      app.config.assets.paths << root.join("app/assets/javascript").to_s
      app.config.assets.precompile += %w[solid_dashboard/application.css solid_dashboard/application.js]
    end
  end
end
