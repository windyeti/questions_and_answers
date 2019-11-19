Rails.application.routes.draw do

  devise_for :users, path: :account, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :voteable do
    post :vote_up, on: :member
    post :vote_down, on: :member
    delete :vote_reset, on: :member
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
