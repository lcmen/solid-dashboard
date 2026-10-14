module SolidDashboard
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :set_app
    helper_method :app

    layout "solid_dashboard/application"

    private

    attr_reader :app

    def set_app
      @app = SolidDashboard.app
    end
  end
end
