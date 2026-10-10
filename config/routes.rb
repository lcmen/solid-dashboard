SolidDashboard::Engine.routes.draw do
  root "dashboard#show", defaults: {section: "overview"}
  get "jobs", to: "dashboard#show", defaults: {section: "jobs"}
  get "processes", to: "dashboard#show", defaults: {section: "processes"}
  get "recurring", to: "dashboard#show", defaults: {section: "recurring"}
  get "cache", to: "dashboard#show", defaults: {section: "cache"}
  get "entries", to: "dashboard#show", defaults: {section: "entries"}
  get "events", to: "dashboard#show", defaults: {section: "events"}
end
