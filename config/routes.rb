Rails.application.routes.draw do

  devise_for :users, path: :account

  root to: 'questions#index'

  resources :questions, shallow: true do
    post :create_vote, on: :member
    resources :answers, only: [:create, :edit, :update, :destroy] do
      patch :best, on: :member
      post :create_vote, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  get 'user_rewards', to: 'rewards#user_rewards'
  # resources :votes, only: [:create]

end
