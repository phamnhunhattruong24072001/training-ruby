Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  devise_for :user_teams

  get    "",                          to: "training/home#index",                        as: :home
  get    "login",                     to: "training/auth#login",                        as: :login
  post   "login",                     to: "training/auth#authenticate",                 as: :authenticate
  get    "logout",                    to: "training/auth#logout",                       as: :logout
  get    "change-password",           to: "training/auth#change_password",              as: :change_password
  post   "change-password",           to: "training/auth#handle_change_password",       as: :handle_change_password
  get    "forgot-password",           to: "training/auth#forgot_password",              as: :forgot_password
  post   "forgot-password",           to: "training/auth#handle_forgot_password",       as: :handle_forgot_password
  get    "reset-password/:token",     to: "training/auth#reset_password",               as: :reset_password
  post   "reset-password/:token",     to: "training/auth#handle_reset_password",        as: :handle_reset_password
  get    "profile",                   to: "training/auth#profile",                      as: :profile
  post   "profile",                   to: "training/auth#update_profile",               as: :update_profile

  get    "team/add",                  to: "training/team#add",                          as: :team_add
  get    "team/list",                 to: "training/team#index",                        as: :team_list
  post   "team/add",                  to: "training/team#create",                       as: :team_create
  get    "team/edit/:id",             to: "training/team#edit",                         as: :team_edit
  match  "team/update/:id",           to: "training/team#update",                       via: [ :patch, :post ], as: :team_update
  get    "team/destroy/:id",          to: "training/team#destroy",                      as: :team_destroy

  get    "user/add",                  to: "training/user#add",                          as: :user_add
  get    "user/list",                 to: "training/user#index",                        as: :user_list
  post   "user/add",                  to: "training/user#create",                       as: :user_create
  get    "user/edit/:id",             to: "training/user#edit",                         as: :user_edit
  match  "user/update/:id",           to: "training/user#update",                       via: [ :patch, :post ], as: :user_update
  get    "user/destroy/:id",          to: "training/user#destroy",                      as: :user_destroy

  # API routes
  namespace :api do
    namespace :v1 do
      post "auth/login",              to: "auth#login"
      post "auth/register",           to: "auth#register"
      get "auth/profile",             to: "auth#profile"
      delete "auth/logout",           to: "auth#logout"
      post "auth/forgot-password",    to: "auth#forgot_password"
      post "auth/reset-password",     to: "auth#reset_password"
      post "auth/change-password",    to: "auth#change_password"

      resources :users, only: [ :create, :index, :show, :update, :destroy ]
    end
  end
end
