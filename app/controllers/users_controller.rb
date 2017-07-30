class UsersController < ApplicationController
  before_action :authenticate_user!

  def suggestions
    @user = current_user
    @page = "suggestions"
    @suggestions = User.select{ |user| current_user.unrelated?(user) }
  end

  def outgoing
    @user = current_user
    @page = "outgoing"
    @outgoing = User.select{ |user| current_user.pending_request?(user) }
  end

  def requests
    @user = current_user
    @page = "request"
    @requests = User.select{ |user| current_user.awaiting_confirm?(user) }
  end

  def show
    @page = "profile"
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:user)
    @comment = Comment.new
  end

#  def my_friends
#    @friends = current_user.friends
#  end

  def friends
    if params[:id] == current_user.id
      redirect_to "/friends"
    elsif params[:id] == 0
      @user = current_user
      @friends = current_user.friends
    else
      @user = User.find(params[:id])
      @friends = @user.friends
    end
  end

  def photos
    @user = User.find(params[:id])
  end

  def add_avatar
    @user = current_user
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to current_user
    else
      render 'add_avatar'
    end
  end

  private
    def user_params
      params.require(:user).permit(:avatar)
    end

end
