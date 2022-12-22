Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  constraints(ClientDomainConstraint.new) do
    root to: "home#index"
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    resource :me
    namespace :users, path: '' do
      resources :addresses
      resources :invite_people, only: :index
      resources :lottery
      resources  :shop
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root to: "home#index"
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      resources :users
      resources :items do
        put :start, :pause, :end, :cancel
      end
      resources :categories
      resources :bets do
        put :cancel
      end
      resources :winners do
        put :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
      resources :offers
      resources :orders do
        put :pay, :cancel
      end
    end
  end

  namespace :api do
    resources :regions, only: :index, defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json } do
        resources :city_municipalities, only: :index, defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end
      end
    end
  end
end
