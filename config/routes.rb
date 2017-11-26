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
      resources :rooms, only: [:index, :show]
      resources :records, only: [:index, :update]
      resources :villages, only: [:show] do
        member do
          get 'remaining_time'
          get 'go_next_day'
        end
      end
    end
  end
end
