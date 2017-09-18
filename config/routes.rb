Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get '/test', to: 'static_pages#test'
  get '/friends', to: 'users#friends' , id: 0
  get '/requests', to: 'users#requests'
  get '/outgoing', to: 'users#outgoing'
  get '/suggestions', to: 'users#suggestions'
  get '/add_avatar', to: 'users#add_avatar'
  get '/photos', to: 'users#photos', id: 0
  resources :users, only: [:show, :update] do
    member do
      get :friends
      get :photos
    end
#    collection do
#      get :suggestions
#    end
  end
  resources :friendships, only: [:create, :destroy, :update]
  resources :friend_requests, only: [:create, :destroy, :update]
  resources :posts, only: [:new, :create, :edit, :update, :destroy, :show]
  resources :comments, only: [:create, :destroy, :update, :edit] do
    member do
      get :show_edit_comment_window, as: 'window'
    end
  end
  get 'show_edit_comment_window', to: 'comments#show_edit_comment_window'
  resources :likes, only: [:create, :destroy]
  resources :post_attachments
  get '/sign_in', to: 'users#sign_in'
  get '/get_comments', to: 'comments#get_comments'
end
