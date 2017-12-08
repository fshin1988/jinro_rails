Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users

  resources :villages, except: :show do
    member do
      get 'join'
      get 'exit'
      get 'start'
    end
    resources :rooms, only: [:show]
  end
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :records, only: [:update]
      resources :villages, only: [:show] do
        member do
          get 'remaining_time'
          get 'proceed'
          get 'divine'
          get 'see_soul'
        end
      end
    end
  end
end
