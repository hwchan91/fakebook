class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    unless session[:forwarding_url] == request.referrer
      session[:forwarding_url] = request.referrer if request.get?
    end
  end

    protected
      def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password) }
          devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :current_password) }
      end

      #redirects to show page after sign in; default redirects to root
      def after_sign_in_path_for(user)
        current_user
      end


end
