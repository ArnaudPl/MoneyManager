class TransactionsController < ApplicationController
  before_filter :authorize

  def new
    @transaction = Transaction.new
    @account = Account.find(params[:account_id])
    @balance = calculateAccountCurrentBalance(@account.id)
  end

  def create
    @account = Account.find(params[:account_id])
    @transactionSave = @account.transactions.new(transaction_params)
    if @transactionSave.save
      flash[:success] = t('.success-transaction')
      redirect_to account_path(@account)
    else
      flash[:error] = t('.error-transaction')
      render 'new'
    end
  end

  def destroy
    @account = Account.find(params[:account_id])
    @transaction = @account.transactions.find(params[:id])
    if @transaction.destroy
      flash[:success] = t('.success-transaction-destroy')
      redirect_to request.referer
    else
      flash[:error] = t('.error-transaction-destroy')
      redirect_to request.referer
    end
  end

private

  def transaction_params
    params.require(:transaction).permit(:label, :amount, :account_id, :user_id, :withdraw)
  end
end
