class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:test]
  def home
    if current_user
      @feed = current_user.feed
      @post = current_user.posts.build
    end

  end

  def test
  end
end
