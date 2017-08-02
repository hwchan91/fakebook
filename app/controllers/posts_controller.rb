class PostsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :post_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
#    @post_attachment = @post.post_attachments.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
#      if !params[:post_attachments].nil?
#        params[:post_attachments]['picture'].each do |p|
#          @post_attachment = @post.post_attachments.create!(:picture  => p)
#        end
#      end
      redirect_to request.referrer || root_url
#      redirect_to root_url
    else
#      @post_attachment = @post.post_attachments.build
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
    @page = "individual_post"
    @post = Post.find(params[:id])
    @comment = Comment.new
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
