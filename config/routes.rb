Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users to home
    get "users", to: "pages#home"
  end

  devise_for :users

  root "pages#home"
end
