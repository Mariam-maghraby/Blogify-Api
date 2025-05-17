Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Resources
  resources :posts
  resources :comments, only: [ :create, :update, :destroy ]
  resources :users, only: [ :index, :update, :destroy ]

  # Authentication
  post "/signup", to: "users#create"
  post "/login", to: "sessions#create"
end
