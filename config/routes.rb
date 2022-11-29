Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  constraints(ClientDomainConstraint.new) do
    resources :home do
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
end
