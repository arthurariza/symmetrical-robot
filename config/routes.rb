require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"

  resource :cart, controller: "carts", only: %i[show create] do
     post "add_item", to: "carts/products#create"
     delete "/:product_id", to: "carts/products#destroy"
  end

  namespace :users do
    resources :registrations, only: [ :create ]
    resources :authentications, only: [ :create ]
  end

  match "signin", to: "users/authentications#create", via: :post
  match "signup", to: "users/registrations#create", via: :post
end
