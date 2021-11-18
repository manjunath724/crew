Rails.application.routes.draw do
  devise_for :users

  # Other CRUD actions can be enabled per need basis
  resources :members, only: :index do
    post :vote, on: :member
  end

  root "members#index"
end
