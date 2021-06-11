Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :reservations, :except => [:show]
      resources :items, :except => [:show]
      resources :brands, :except => [:show]
      resources :users, :except => [:show]
      post 'authenticate', to: 'authentication#create'
    end
  end
end
