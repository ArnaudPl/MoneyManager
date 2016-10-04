class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def menus
    @menus = '<li><a href="' + root_path + '">' + I18n.t('.homepage') + '</a></li>'
    if current_user
      @menus += '<li><a href="' + logout_path + '">' + I18n.t('.logout') + '</a></li>'
    else
      @menus += '<li><a href="' + login_path + '">' + I18n.t('.login') + '</a></li>'
    end
  end
  helper_method :menus

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_path unless current_user
  end
end
