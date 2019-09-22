Rails.application.routes.draw do

  devise_for :users, path: :account
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers, only: [:create, :destroy]
  end

end
