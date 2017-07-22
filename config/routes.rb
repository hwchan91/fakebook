Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users
  get '/test', to: 'static_pages#test'
  get '/friends', to: 'users#friends' , id: 0
  get '/requests', to: 'users#requests'
  get '/outgoing', to: 'users#outgoing'
  get 'suggestions', to: 'users#suggestions'
  resources :users, only: [:show] do
    member do
      get :friends
    end
#    collection do
#      get :suggestions
#    end
  end
  resources :friendships, only: [:create, :destroy, :update]
  resources :friend_requests, only: [:create, :destroy, :update]
  resources :posts, only: [:create, :edit, :update, :destroy, :show]

end
