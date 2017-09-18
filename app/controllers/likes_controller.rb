class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @friend_ids = current_user.friend_ids
    current_user.like(@post)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end


  #Triggers on Unfriend
  def destroy
    @post = Like.find_by(post_id: params[:post_id], user_id: current_user.id).post
    current_user.unlike(@post)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
