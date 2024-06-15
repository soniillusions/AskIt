# frozen_string_literal: true

Rails.application.routes.draw do
  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  namespace :api do
    resources :tags, only: :index
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get 'up' => 'rails/health#show', as: :rails_health_check

    resource :session, only: %i[new create destroy]

    resources :users, only: %i[new create edit update]

    resources :questions, concerns: :commentable do
      resources :answers, expect: %i[new show]
    end

    resources :answers, expect: %i[new show], concerns: :commentable

    namespace :admin do
      resources :users, only: %i[index create]
    end

    root 'pages#index'
  end
end
