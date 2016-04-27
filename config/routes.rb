Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :cities do
    resources :hotels, only: [] do
      collection do
        get :unmatched
        get :dupicated
      end
    end
  end

  root 'cities#index'
end
