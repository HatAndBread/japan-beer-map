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

  get "/race", to: "visits#race", as: "race"
  resources :profiles, only: [:show, :edit, :update]
  resources :places do
    resources :reviews, only: [:create, :edit, :show]
    resources :place_updates, only: [:index, :update]
  end
  resources :visits, only: [:create, :index]

  get "admin", to: "admin#index"
  namespace :admin do
    resources :places, only: [:show, :update, :destroy]
    resources :place_updates, only: [:show, :update, :destroy] do
      get "merge", to: "merge"
    end
  end

  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"
end
