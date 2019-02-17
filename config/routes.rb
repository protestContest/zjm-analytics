Rails.application.routes.draw do
  get '/track', to: 'hits#track', as: 'tracking'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'home#dashboard', as: :dashboard
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    resources :sites

    resources :account_transfers
    get '/account_transfers/:id/accept', to: 'account_transfers#accept', as: :accept_account_transfer
    get '/account_transfers/:id/reject', to: 'account_transfers#reject', as: :reject_account_transfer

    resources :users, only: [:show] do
      resources :accounts
    end

    get '/accounts/:id/switch', to: 'accounts#switch', as: :switch_account

  end
end
