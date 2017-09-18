class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :comment_correct_user, only: [:edit, :update, :destroy, :show_edit_comment_window]

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
    store_location
  end

  def update
    if @comment.update_attributes(comment_params)
      @updated_comment = @comment
      @comment = Comment.new
      respond_to do |format|
        format.html { redirect_back_or(root_url) }
        format.js
      end
    else
      render 'edit'
    end
  end

  def show_edit_comment_window
    if @change.nil?
      @changed = false
    else
      @changed = true
    end
    store_location
    respond_to do |format|
      format.html { redirect_to edit_comment_path(@comment) }
      format.js
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def get_comments
    @post_id = params[:post_id]
    @comments = Comment.where(post_id: params[:post_id])
    respond_to do |format|
      format.js { render file: "comments/popup.js.erb"}
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end

  def comment_correct_user
    @comment = current_user.comments.find(params[:id])
    redirect_to root_url if @comment.nil?
  end

end
