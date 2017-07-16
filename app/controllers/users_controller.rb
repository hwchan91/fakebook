class UsersController < ApplicationController
  def suggestions
    @suggestions = User.select{ |user| current_user.unrelated?(user) }
  end

  def requests
    @requests = current_user.request.includes(:friend) #returns list of friendships
  end

  def friends
    @friends = current_user.confirmed_friends.includes(:friend) #returns list of friendships
  end

  def show
    @user = User.find(params[:id])
  end
end
