class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # overriding CanCan::ControllerAdditions
  def current_ability
    if current_account.kind_of?(GameOwner)
      @current_ability ||= OwnerAbility.new(current_account)
    else
      @current_ability ||= UserAbility.new(current_account)
    end
  end

end
