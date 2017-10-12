class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:test]
  def home
    if current_user
      @feed = CustomRelation.new(current_user, params[:page] , params[:last_id])
 #     @feed = current_user.feed.page(params[:page]).per(20)
      @post = current_user.posts.build
      @comment = Comment.new
      @friend_ids = current_user.friend_ids
    end
  end

  def newest
    @newest = RedisRelation.new(params[:page] , params[:last_id])
    @comment = Comment.new
    @friend_ids = current_user.friend_ids
  end

end
