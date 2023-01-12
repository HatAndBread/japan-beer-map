Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users to home
    get "users", to: "pages#home"
  end

  devise_for :users

  get "/:locale" => "pages#home"
  root "pages#home"

  scope "(:locale)", locale: /en|ja/ do
    resources :users
    resources :places, only: [:new]
  end

  get "/admin/index", to: "admin#index"
  resources :places, only: [:show, :create]
  resources :visits, only: [:create]
end
