Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users to home
    get "users", to: "pages#home"
  end

  devise_for :users

  root "pages#home"

  scope "(:locale)", locale: /en|ja/ do
    resources :users
    resources :places, only: [:new]
  end

  resources :places, only: [:show, :create]
  resources :visits, only: [:create]

  get "admin", to: "admin#index"
  namespace :admin do
    resources :places, only: [:show, :update, :destroy]
  end
end
