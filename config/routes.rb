Rails.application.routes.draw do
  resources :authors
  resources :books
  resources :users
  resources :rentals
  post '/pay', to: 'rentals#pay'
  post '/return', to: 'rentals#return'
  post '/complete', to: 'rentals#complete'

  root 'books#index'
end
