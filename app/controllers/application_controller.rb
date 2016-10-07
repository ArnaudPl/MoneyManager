class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper #For number_to_currency
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def menus
    homepage = t('layouts.application.menus.homepage')
    logout = t('layouts.application.menus.logout')
    accounts = t('layouts.application.menus.accounts-menu')
    login = t('layouts.application.menus.login')
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

  def calculateAccountCurrentBalance(account_id)
      withdraws = Transaction.all.where(withdraw: true).where(account_id: account_id).where(user_id: current_user.id).sum(:amount)
      deposits = Transaction.all.where(withdraw: false).where(account_id: account_id).where(user_id: current_user.id).sum(:amount)
      balance = deposits - withdraws
      if balance == 0
        number_to_currency(0)
      else
        number_to_currency(balance)
      end
  end
  helper_method :calculateAccountCurrentBalance

  def authorize
    if !current_user
      flash[:error] = t('layouts.application.authorize.must-login')
      redirect_to login_path
    end
  end
end
