class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.referrer if request.get?
  end

  def store_location_before_signed_in
    session[:original_url] = request.original_url
  end

  # If I want to eager load on current_user, this is what to do:
  # def current_user
  #   if params[:controller] == "static_pages"
  #     @current_user ||= super && User.includes(:friendships).find(@current_user.id)
  #   else
  #     current_user
  #   end
  # end

  # def add_record_to_redis
  #   RedisWorker.perform_async
  # end

  # def remove_record_from_redis(post, updated_at = nil)
  #   updated_at ||= post.updated_at.to_i.to_s
  #   $redis.zremrangebyscore("user_#{post.user_id}_posts", updated_at, updated_at)
  # end

  # def remove_record_from_redis(post)
  #   $redis.zremrangebyscore("newest_posts", post.id, post.id)
  # end


    protected
      def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password) }
          devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :current_password) }
      end

      #redirects to show page after sign in; default redirects to root
      def after_sign_in_path_for(user)
        if session[:original_url]
          session[:original_url]
        else
          root_path
        end
      end


end
