Rails.application.routes.draw do
  resources :cities do
    resources :hotels
  end
end
