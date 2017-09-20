class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:test]
  def home
    if current_user
      @feed = current_user.feed.page(params[:page]).per_page(10)
#      @feed = redis_feed(current_user)
      @post = current_user.posts.build
#      @post_attachment = @post.post_attachments.build
      @comment = Comment.new
#      @comments = Comment.all
      @friend_ids = current_user.friend_ids
    end

  end

  def test
  end

  def redis_feed(user)
    friend_and_self_ids = user.friends.pluck(:id) + [user.id]
    set_arr = []
    friend_and_self_ids.each {|id| set_arr.push("user_#{id}_posts")}
    weight_arr = []
    friend_and_self_ids.length.times{weight_arr.push(1)}
    $redis.zunionstore("out", set_arr, weights: weight_arr)
    $redis.zrevrange("out", 0, -1)
  end
end
