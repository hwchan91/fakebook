class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:test]
  def home
  end

  def test
  end
end
