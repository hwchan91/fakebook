class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:test]
  def home
    if current_user
      @feed = current_user.feed
      @post = current_user.posts.build
#      @post_attachment = @post.post_attachments.build
      @comment = Comment.new
    end

  end

  def test
  end
end
