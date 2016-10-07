class AccountsController < ApplicationController
  before_action :authorize

  def index
    @addTooltip = t('.tooltip-add')
    @removeTooltip = t('.tooltip-remove')
    @editTooltip = t('.tooltip-edit')

    @accounts = Account.all
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.user_id = current_user.id
    if @account.save
      flash[:success] = t('.success')
      redirect_to accounts_path
    else
      flash[:error] = t('.error')
      render 'new'
    end
  end

  def show
    @account = Account.find(params[:id])
    @balance = calculateAccountCurrentBalance(@account.id)
  end

  def edit
    @account = Account.find(params[:id])
    @nameLabel = t('.nameAccount')
    @confirmText = t('.sure')
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      flash[:success] = t('.success-account-update')
      redirect_to accounts_path
    else
      @account.name = Account.find(params[:id]).name #Put back the name of the account before trying the update
      flash[:error] = t('.error-account-update')
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.destroy
      flash[:success] = t('.success-account-destroy')
      redirect_to accounts_path
    else
      flash[:error] = t('.error-account-destroy')
      render 'edit'
    end
  end

  def printAccountLatestTransactions(account_id)
    html = ""
    transactions = Transaction.all.where(account_id: account_id).where(user_id: current_user.id).order(:created_at).limit(10)
    transactions.each do |transaction|
      if transaction.withdraw
        html += '<li class="collection-item red row white-text"><span class="col s1 center">-</span><span class="col s5 truncate">'+ transaction.label + '</span>'
        html += '<span class="col s3">' + number_to_currency(transaction.amount).to_s + '</span>'
        html += '<span class="col s2">' + l(transaction.created_at, format: :date_day_month) + '</span>'
        html += view_context.link_to '<i class="material-icons white-text">delete</i>'.html_safe, [transaction.account, transaction], method: :delete, data: { confirm: t('accounts.destroy.transactions.confirmation') }, class: "transaction-row"
        html += '</li>'
      else
        html += '<li class="collection-item green row white-text"><span class="col s1 center">+</span><span class="col s5 truncate">' + transaction.label + '</span>'
        html += '<span class="col s3">' + number_to_currency(transaction.amount).to_s + '</span>'
        html += '<span class="col s2">' + l(transaction.created_at, format: :date_day_month) + '</span>'
        html += view_context.link_to '<i class="material-icons white-text normal">delete</i>'.html_safe, [transaction.account, transaction], method: :delete, data: { confirm: t('accounts.destroy.transactions.confirmation') }, class: "transaction-row"
        html += '</li>'
      end
    end
    if html == ""
      html = '<li class="collection-item center grey lighten-3">' + t('transactions.empty') + '</li>'
      html += '<li class="collection-item center grey lighten-3"><a href="' + new_account_transaction_path(account_id) + '?isWithdraw=true">' + t('transactions.add') + '</a></li>'
    else
      html = '<li class="collection-item grey lighten-2 row"><span class="col s1">+/-</span><span class="col s5 truncate">' + t('transactions.label') + '</span><span class="col s3">' + t('transactions.amount') + '</span><span class="col s2">' + t('transactions.date') + '</span></li>' + html
    end
    html
  end
  helper_method :printAccountLatestTransactions

  def account_params
    params.require(:account).permit(:name)
  end
end
