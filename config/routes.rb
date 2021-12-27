Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

  root to: 'home#index'
  devise_for :users
  post '/upload', to: 'search_results#upload'
  get '/raw_code/:id', to: 'search_results#raw_code', as: 'raw_code'
  delete '/destroy/:id', to: 'search_results#destroy', as: 'destroy_search'
end
