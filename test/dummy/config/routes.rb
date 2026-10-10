Rails.application.routes.draw do
  mount SolidDashboard::Engine => ENV.fetch("DASHBOARD_MOUNT", "/solid-dashboard")
end
