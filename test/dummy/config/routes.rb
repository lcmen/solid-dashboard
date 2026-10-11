Rails.application.routes.draw do
  root "home#show"
  post "jobs/slow", to: "jobs#create_slow", as: :slow_job
  post "jobs/fast", to: "jobs#create_fast", as: :fast_job
  mount SolidDashboard::Engine => ENV.fetch("DASHBOARD_MOUNT", "/solid-dashboard")
end
