Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users

  resources :villages do
    member do
      get 'join'
      get 'exit'
    end
    resources :rooms, only: [:show]
  end
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :rooms, only: [:index, :show]
      resources :records, only: [:index, :update]
    end
  end
end
