Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :establishments, only: [:new, :create, :show, :edit, :update]
  resources :opening_hours, only: [:index, :new, :create, :edit, :update]
  resources :menu_items, only: [:index] do
    get 'dishes', on: :collection
  end
end
