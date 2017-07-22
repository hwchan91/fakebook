class UsersController < ApplicationController
  before_action :authenticate_user!

  def suggestions #and ongoing, for now
    @page = "suggestions"
    @suggestions = User.select{ |user| current_user.unrelated?(user) }
  end

  def outgoing
    @page = "outgoing"
    @outgoing = User.select{ |user| current_user.pending_request?(user) }
  end

  def requests
    @page = "request"
    @requests = User.select{ |user| current_user.awaiting_confirm?(user) }
  end

  def show
    @page = "profile"
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:user)
  end

#  def my_friends
#    @friends = current_user.friends
#  end

  def friends
    if params[:id] == current_user.id
      redirect_to "/friends"
    elsif params[:id] == 0
      @friends = current_user.friends
    else
      @user = User.find(params[:id])
      @friends = @user.friends
    end
  end

end
