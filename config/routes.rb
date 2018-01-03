Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
      resources :records, only: [:show] do
        member do
          put 'vote'
          put 'attack'
          put 'divine'
          put 'guard'
        end
      end
      resources :villages, only: [:show] do
        member do
          get 'remaining_time'
          get 'divine'
          get 'see_soul'
        end
      end
    end
  end

  resources :manuals, only: %i[show new edit create update destroy]
end
