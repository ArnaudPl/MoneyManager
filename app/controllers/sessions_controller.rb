class SessionsController < ApplicationController

  def new
  end

  #Login
  def create
    user = User.find_by_username(params[:user][:username])
    # If the user exists AND the password entered is correct.
    #flash[:warning] = user #.authenticate(params[:password_digest])
    if user && user.authenticate(params[:user][:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      flash[:success] = "You have been successfully connected !"
      redirect_to '/'
    else
      # If user's login doesn't work, send them back to the login form.
      flash[:error] = "Please verify your informations."
      redirect_to '/login'
    end
  end

  #Logout
  def destroy
    session[:user_id] = nil
    flash[:success] = "You have been disconnected."
    redirect_to '/login'
  end

end
