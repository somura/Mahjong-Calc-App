Rails.application.routes.draw do
  resources :top
  resources :my_page
  resources :user
  resources :login
  resources :logout
  resources :register
  resources :friend
  resources :friend_request
  resources :tournament do
    resources :game do
      resources :game_memo
    end
    resources :tournament_result
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'my_page#index'
end
