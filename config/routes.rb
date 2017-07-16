Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users
  get '/test', to: 'static_pages#test'
  resources :users, only: [:show] do
    member do
      get :friends, :requests
    end
    collection do
      get :suggestions
    end
  end
  resources :friendships, only: [:create, :destroy, :update]

end
