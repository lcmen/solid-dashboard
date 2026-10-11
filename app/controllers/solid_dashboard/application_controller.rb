module SolidDashboard
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    layout "solid_dashboard/application"
  end
end
