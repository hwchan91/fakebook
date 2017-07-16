class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:friend_id])
    current_user.friend(@user)
    respond_to do |format|
      format.html { redirect_to suggestions_users_url }
      format.js
    end
  end

  def destroy
    @user = Friendship.find(params[:id]).friend
    current_user.unfriend(@user)
    respond_to do |format|
      format.html { redirect_to redirect_to requests_user_url(current_user) }
      format.js
    end
  end

  def update
    @user = Friendship.find(params[:id]).friend
    current_user.confirm(@user)
    respond_to do |format|
      format.html { redirect_to redirect_to requests_user_url(current_user) }
      format.js
    end
  end

end
