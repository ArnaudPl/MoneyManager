class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    # Hash the user password into the db
    user.password_digest = BCrypt::Password.create(params[:user][:password_digest])
    user.inscription_date = Time.zone.now
    if user.save
      session[:user_id] = user.id
      flash[:success] = "You have successfully created your account !"
      redirect_to '/'
    else
      flash[:error] = "Please verify your informations."
      redirect_to '/signup'
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :firstname, :username)
  end
end
