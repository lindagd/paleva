Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :establishment, only: [:new, :create]
end
