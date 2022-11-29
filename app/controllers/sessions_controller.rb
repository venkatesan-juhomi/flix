class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if session[:intended_url]
        redirect_to session[:intended_url]
        session[:intended_url] = nil
      else
        redirect_to user
      end
    else
      flash[:alert] = "Invaild email or password"
      redirect_to signin_path

      # flash.now[:alert] = "Invaild email or password"
      # render :new
    end
  end

  def new
  end

  def destroy
    session[:user_id] = nil
    redirect_to signin_path
  end
end
