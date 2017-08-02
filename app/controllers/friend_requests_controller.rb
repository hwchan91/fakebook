class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:receiver_id])
    @page = params[:page]
    current_user.friend_request(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @user = FriendRequest.find(params[:id]).receiver
    @page = params[:page]
    current_user.undo_friend_request(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end


  #triggers when Deny Request from Another
  def update
    @user = FriendRequest.find(params[:id]).requestor
    @page = params[:page]
    current_user.deny_request(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

end
