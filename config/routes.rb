Rails.application.routes.draw do
  get 'profiles/edit'
  devise_scope :user do
    # Redirests signing out users to home
    get "users", to: "pages#home"
  end

  devise_for :users

  root "pages#home"

  scope "(:locale)", locale: /en|ja/ do
    resources :users
    resources :places, only: [:new]
    get "/map", to: "pages#map", as: "map"
  end

  resources :profiles, only: [:show, :edit, :update]
  resources :places, only: [:show, :create] do
    resources :reviews, only: [:create, :edit, :show]
  end
  resources :visits, only: [:create, :index]

  get "admin", to: "admin#index"
  namespace :admin do
    resources :places, only: [:show, :update, :destroy]
  end
end
