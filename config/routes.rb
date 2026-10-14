SolidDashboard::Engine.routes.draw do
  root "dashboard#show"
  resource :cache, only: :show, controller: "cache"
  resources :entries, only: :index
  resources :events, only: :index
  resources :jobs, only: [:index, :show, :destroy] do
    post :retry, on: :member
  end
  resources :processes, only: :index
  resources :recurring_tasks, path: "recurring", only: :index
end
