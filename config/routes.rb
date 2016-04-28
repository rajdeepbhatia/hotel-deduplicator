Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'cities#index'
  resources :cities do
    resources :hotels, only: [] do
      collection do
        get :unmatched
        get :dupicated
      end
    end
  end
  resources :duplicate_hotel_records, only: [:create] do
    put :change_duplicate_status, on: :member
  end
end
