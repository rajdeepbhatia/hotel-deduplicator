Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :cities do
    resources :hotels
  end

  root 'cities#index'
end
