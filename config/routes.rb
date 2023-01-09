Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users to home
    get "users", to: "pages#home"
  end

  devise_for :users

  get "/:locale" => "pages#home"
  root "pages#home"

  get "/a", to: "admin#index"

  scope "(:locale)", locale: /en|ja/ do
    resources :users
    resources :places, only: [:show]
  end
end
