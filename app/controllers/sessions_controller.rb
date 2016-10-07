class SessionsController < ApplicationController

  def new
  end

  #Login
  def create
    user = User.find_by_username(params[:user][:username])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:user][:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      flash[:success] = t('.success-login')
      redirect_to root_path
    else
      # If user's login doesn't work, send them back to the login form.
      flash[:error] = t('.error-login')
      redirect_to login_path
    end
  end

  #Logout
  def destroy
    session[:user_id] = nil
    flash[:success] = t('.success-disconnect')
    redirect_to login_path
  end
end
