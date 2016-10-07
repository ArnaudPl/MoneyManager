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

  def edit
    @account = Account.find(params[:id])
    @nameLabel = I18n.t('.nameAccount')
    @confirmText = I18n.t('.sure')
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      flash[:success] = I18n.t('.success-account-update')
      redirect_to accounts_path
    else
      @account.name = Account.find(params[:id]).name #Put back the name of the account before trying the update
      flash[:error] = I18n.t('.error-account-update')
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.destroy
      flash[:success] = I18n.t '.success-account-destroy'
      redirect_to accounts_path
    else
      flash[:error] = I18n.t '.error-account-destroy'
      render 'edit'
    end
  end

  def printAccountLatestTransactions(account_id)
    html = ""
    transactions = Transaction.all.where(account_id: account_id).order(:created_at)
    transactions.each do |transaction|
      if transaction.withdraw
        html += '<li class="collection-item red row white-text"><span class="col s1 center">-</span><span class="col s5 truncate">'+ transaction.label + '</span>'
        html += '<span class="col s3">' + number_to_currency(transaction.amount).to_s + '</span>'
        html += '<span class="col s2">' + l(transaction.created_at, format: :date_day_month) + '</span>'
        html += view_context.link_to '<i class="material-icons white-text">delete</i>'.html_safe, [transaction.account, transaction], method: :delete, data: { confirm: 'Are you sure?' }
        html += '</li>'
      else
        html += '<li class="collection-item green row white-text"><span class="col s1 center">+</span><span class="col s5 truncate">' + transaction.label + '</span>'
        html += '<span class="col s3">' + number_to_currency(transaction.amount).to_s + '</span>'
        html += '<span class="col s2">' + l(transaction.created_at, format: :date_day_month) + '</span>'
        html += view_context.link_to '<i class="material-icons white-text">delete</i>'.html_safe, [transaction.account, transaction], method: :delete, data: { confirm: 'Are you sure?' }
        html += '</li>'
      end
    end
    if html == ""
      html = '<li class="collection-item center grey lighten-3">' + I18n.t('.no-transactions') + '</li>'
      html += '<li class="collection-item center grey lighten-3"><a href="' + new_account_transaction_path(account_id) + '?isWithdraw=true">' + I18n.t('.add-transaction') + '</a></li>'
    else
      html = '<li class="collection-item grey lighten-2 row"><span class="col s1">+/-</span><span class="col s5 truncate">' + I18n.t('.label') + '</span><span class="col s3">' + I18n.t('.amount') + '</span><span class="col s2">' + I18n.t('.date') + '</span></li>' + html
    end
    html
  end
  helper_method :printAccountLatestTransactions

  def account_params
    params.require(:account).permit(:name)
  end
end
