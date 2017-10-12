class PostsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, except: [:show]
  before_action :post_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to request.referrer || root_url
    else
      render 'new'
    end
  end

  def destroy
    @post.destroy
    if request.referrer.to_s.include?(@post.id.to_s)
      redirect_to root_url
    else
      redirect_to request.referrer || root_url
    end
  end

  def edit
    if !request.referrer.to_s.include?("edit")
      store_location
    end
    @page = "edit_post"
  end

  def update
    if @post.update_attributes(post_params)
      redirect_back_or(root_url)
    else
      @page = "edit_post"
      render 'edit'
    end
  end

  def show
    store_location_before_signed_in
    @page = "individual_post"
    @post = Post.includes(:user, :liked_users).find_by(id: params[:id])
    @comment = Comment.new
    @friend_ids = current_user.friend_ids if current_user
    if @post.nil?
      render 'not_found'
    end
  end

  def not_found
  end

  private
    def post_params
      #params.require(:post).permit(:content, post_attachment_attributes: [:id, :post_id, :picture])
      params.require(:post).permit(:content, post_attachments_attributes: ["picture", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
    end

    def post_correct_user
      @post = current_user.posts.find(params[:id])
      redirect_to root_url if @post.nil?
    end
end
