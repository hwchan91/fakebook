class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:test]
  def home
    @feed = current_user.feed
    @post = current_user.posts.build


  end

  def test
  end
end
