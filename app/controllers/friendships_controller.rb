class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  #Triggers on Confirm request
  def create
    @user = User.find(params[:friend_id])
    @page = params[:page]
    current_user.confirm_request(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end


  #Triggers on Unfriend
  def destroy
    @user = Friendship.find(params[:id]).friend
    @page = params[:page]
    current_user.unfriend(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end


  #triggers when undo confirm request
  def update
    @user = FriendRequest.find_by(requestor_id: params[:requestor_id]).requestor
    current_user.undo_confirm_request(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

end
