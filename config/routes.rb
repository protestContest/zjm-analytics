Rails.application.routes.draw do
  get '/track', to: 'hits#track', as: 'tracking'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'home#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    resources :sites
    resources :users, only: [:show]
  end
end
