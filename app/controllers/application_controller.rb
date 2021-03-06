class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Redirect to sign in page for actions performed on expired session
  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to new_user_session_path, alert: 'You have already signed out or the session has expired.'
  end

  protected

  # Whitelisting attributes for signing up an user
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
  end
end
