class AccountsController < ApplicationController
  before_filter :authorize

  def index
    @addTooltip = I18n.t('.tooltip-add')
    @removeTooltip = I18n.t('.tooltip-remove')
    @editTooltip = I18n.t('.tooltip-edit')

    @accounts = Account.all
  end
end
