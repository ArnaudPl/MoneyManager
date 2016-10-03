class SessionsController < ApplicationController

  def new
    @user = User.new #Init for the form !
  end

  #Login
  def create
    user = User.find_by_username(params[:username])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password_digest])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      redirect_to '/'
    else
      # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
    end
  end

  #Logout
  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end
