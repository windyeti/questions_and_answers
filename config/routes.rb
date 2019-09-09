Rails.application.routes.draw do

  devise_for :users, path: :account
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers
  end

  # resources :users, shallow: true do
  #   resources :questions, shallow: true do
  #     resources :answers
  #   end
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
