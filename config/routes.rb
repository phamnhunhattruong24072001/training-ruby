Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  get "welcome/index"
  root "welcome#index"

  # API routes
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      get "auth/profile", to: "auth#profile"
      delete "auth/logout", to: "auth#logout"
      post "auth/forgot-password", to: "auth#forgot_password"
      post "auth/reset-password", to: "auth#reset_password"
      post "auth/change-password", to: "auth#change_password"

      resources :users, only: [ :create, :index, :show, :update, :destroy ]
    end
  end
end
