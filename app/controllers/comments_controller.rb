class CommentsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    else
      flash[:danger] = "Error"
      redirect_to @post
    end
  end

  def edit
    @post_id = @comment.post_id
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_back_or(root_url)
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to request.referrer || root_url
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end

  def correct_user
    @comment = current_user.comments.find(params[:id])
    redirect_to root_url if @comment.nil?
  end

end
