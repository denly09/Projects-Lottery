Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


  constraints(ClientDomainConstraint.new) do
    root "home#index"
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    resources :homes do
    end
  end

    constraints(AdminDomainConstraint.new) do
      namespace :admin, path: '' do
        root "home#index"
        devise_for :users, controllers: { sessions: 'admin/sessions' }
        resources :users
        resources :home
      end
    end
end
