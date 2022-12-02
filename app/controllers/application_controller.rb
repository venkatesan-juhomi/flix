class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?
    @user = User.find(params[:id])
    @user == current_user
  end

  def require_signin
    if !current_user
      session[:intended_url] = request.url
      redirect_to signin_path, notice:"You are not signed in!!! Please signIn to continue"
    end
  end

  def current_user_admin?
    current_user && current_user.admin
  end

  def require_admin
    redirect_to movies_path, notice: "You are not authorized to do this action" unless current_user_admin?
  end

  helper_method :current_user

  helper_method :current_user?

  helper_method :current_user_admin?
end
