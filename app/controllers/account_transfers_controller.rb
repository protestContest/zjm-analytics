class AccountTransfersController < ApplicationController
  before_action :set_account_transfer, only: [:show, :edit, :update, :destroy]
  before_action :user_owns_account, only: [:create]
  before_action :user_initiated_transfer, only: [:show, :edit, :update, :destroy]

  def new
    @transfer = AccountTransfer.new
  end

  def create
    @transfer = AccountTransfer.new(account_transfer_params)

    respond_to do |format|
      if @transfer.save
        format.html { redirect_to @transfer, notice: 'Account transfer was successfully requested.' }
        format.json { render :show, status: :created, location: @transfer }
      else
        format.html { render :new }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @transfer.update(account_transfer_params)
        format.html { redirect_to @transfer, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer }
      else
        format.html { render :edit }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transfer.destroy
    respond_to do |format|
      format.html { redirect_to user_accounts_url(current_user), notice: 'Account transfer was successfully cancelled.' }
      format.json { head :no_content }
    end
  end

  private

    def set_account_transfer
      @transfer = AccountTransfer.find(params[:id])
    end

    def account_transfer_params
      params.require(:account_transfer).permit(:account_id, :target_owner)
      account = Account.find(params[:account_transfer][:account_id])

      return {
        account: account,
        original_owner: account.owner,
        target_owner: params[:account_transfer][:target_owner]
      }
    end

    def user_owns_account
      account = Account.find(params[:account_transfer][:account_id])
      if account.nil? || account.owner != current_user
        render 'shared/error', notice: 'You cant\'t transfer other accounts', status: :forbidden
      end
    end

    def user_initiated_transfer
      if @transfer.original_owner != current_user
        render 'shared/error', notice: 'You cant\'t see that', status: :forbidden
      end
    end
end