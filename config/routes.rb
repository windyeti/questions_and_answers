Rails.application.routes.draw do


  devise_for :users, path: :account
  root to: 'questions#index'

  resources :questions, shallow: true do
    delete :delete_attachment, on: :member
    resources :answers, only: [:create, :edit, :update, :destroy] do
      patch :best, on: :member
      delete :delete_attachment, on: :member
    end
  end

  resources :attachments, only: [:destroy]

end
