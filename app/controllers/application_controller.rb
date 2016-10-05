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
    homepage = I18n.t('.homepage')
    logout = I18n.t('.logout')
    accounts = I18n.t('.accounts-menu')
    login = I18n.t('.login')
    @menus = '<li><a href="' + root_path + '">' + homepage + '</a></li>'
    if current_user
      @menus += '<li><a href="' + accounts_path + '">' + accounts + '</a></li>'
      @menus += '<li><a href="' + logout_path + '">' + logout + '</a></li>'
    else
      @menus += '<li><a href="' + login_path + '">' + login + '</a></li>'
    end
  end
  helper_method :menus

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    if !current_user
      flash[:error] = I18n.t('must-login')
      redirect_to login_path
    end
  end
end
