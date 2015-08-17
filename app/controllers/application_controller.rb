class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_filter :require_login
  protect_from_forgery with: :exception
  helper_method :current_user
  add_flash_types :error


#-----------> METHOD is used in the googleauth since the api is answering to rails 3.2
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
#----------->
end


#--> Review by Niklas 10:30 27/3-14