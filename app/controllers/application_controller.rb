class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :redirect_to_root
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_root
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :color_of_navbar

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end

  def redirect_to_root
    redirect_to villages_path, alert: 'リクエストしたページは存在しません'
  end

  def after_sign_in_path_for(resource)
    villages_path
  end
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  private

  def color_of_navbar
    @color_of_navbar = 'red'
  end
end
