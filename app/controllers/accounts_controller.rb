class AccountsController < ApplicationController
  before_filter :authorize

  def index
    @addTooltip = I18n.t('.tooltip-add')
    @removeTooltip = I18n.t('.tooltip-remove')
    @editTooltip = I18n.t('.tooltip-edit')

    @accounts = Account.all
  end

  def calculateAccountCurrentBalance(account_id)
      withdraws = Transaction.all.where(withdraw: true).where(account_id: account_id).sum(:amount)
      deposits = Transaction.all.where(withdraw: false).where(account_id: account_id).sum(:amount)
      balance = withdraws - deposits
      if balance == 0
        "0"
      else
        balance
      end
  end
  helper_method :calculateAccountCurrentBalance
end
