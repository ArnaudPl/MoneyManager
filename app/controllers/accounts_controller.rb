class AccountsController < ApplicationController
  before_filter :authorize

  def index
    @addTooltip = I18n.t('.tooltip-add')
    @removeTooltip = I18n.t('.tooltip-remove')
    @editTooltip = I18n.t('.tooltip-edit')

    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
    @balance = calculateAccountCurrentBalance(@account.id)
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

  def printAccountLatestTransactions(account_id)
    html = ""
    transactions = Transaction.all.where(account_id: account_id).order(:created_at)
    transactions.each do |transaction|
      if transaction.withdraw
        html += '<li class="collection-item green row white-text"><span class="col s1 center">+</span><span class="col s5 truncate">' + transaction.label + '</span><span class="col s3">' + transaction.amount.to_s + 'CHF</span><span class="col s2">' + transaction.created_at.strftime("%e %b") + '</span></li>'
      else
        html += '<li class="collection-item red row white-text"><span class="col s1 center">-</span><span class="col s5 truncate">' + transaction.label + '</span><span class="col s3">' + transaction.amount.to_s + 'CHF</span><span class="col s2">' + transaction.created_at.strftime("%e %b") + '</span></li>'
      end
    end
    if html == ""
      html = '<li class="collection-item center grey lighten-3">' + I18n.t('.no-transactions') + '</li>'
    else
      html = '<li class="collection-item grey lighten-2 row"><span class="col s1">+/-</span><span class="col s5 truncate">' + I18n.t('.label') + '</span><span class="col s3">' + I18n.t('.amount') + '</span><span class="col s2">' + I18n.t('.date') + '</span></li>' + html
    end
    html
  end
  helper_method :printAccountLatestTransactions
end
