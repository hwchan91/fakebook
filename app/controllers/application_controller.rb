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
