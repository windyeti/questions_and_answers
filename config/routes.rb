require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  default_url_options host: "localhost:3000"

  resources :searches, only: [:index]

  get '/set_account_email', to: 'emails#new'
  post '/set_account_email', to: 'emails#create'

  resources :subscriptions, only: [:create, :destroy]

  devise_for :users, path: :account, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
         resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true
      end
    end
  end

  concern :voteable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_reset
    end
  end

  resources :questions, shallow: true, concerns: :voteable do
    resources :comments, shallow: true, only: [:create, :destroy], defaults: { commentable: 'questions' }
    resources :answers, only: [:create, :edit, :update, :destroy], concerns: :voteable do
      resources :comments, shallow: true, only: [:create, :destroy], defaults: { commentable: 'answers' }
      patch :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  get 'user_rewards', to: 'rewards#user_rewards'

  mount ActionCable.server => '/cable'
end
