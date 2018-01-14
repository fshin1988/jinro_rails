Rails.application.routes.draw do
  root to: 'welcome#welcome'

  devise_for :users, controllers: {registrations: 'registrations'}
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :villages, except: :show do
    member do
      get 'join'
      get 'exit'
      get 'start'
      get 'ruin'
    end
    resource :kick, only: %i[edit update], module: "villages"
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
      resources :rooms, only: [:show] do
        member do
          get 'posts'
        end
      end
    end
  end

  resources :manuals, only: %i[show new edit create update destroy]
  get 'sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/#{ENV['AWS_BUCKET']}/sitemaps/sitemap.xml.gz")
end
