Rails.application.routes.draw do
  resources :top
  resources :login
  resources :logout
  resources :register

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'top#index'
end
