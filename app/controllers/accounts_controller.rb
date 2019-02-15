class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :user_has_account!, only: [:show]
  before_action :user_owns_account!, only: [:edit, :update, :destroy]

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.owner_id = current_user.id

    respond_to do |format|
      if @account.save
        format.html { redirect_to [@account.owner, @account], notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: [@account.owner, @account] }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to [@account.owner, @account], notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: [@account.owner, @account] }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to user_accounts_url(current_user), notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name)
    end

    def user_has_account!
      if !current_user.has_account @account
        render 'shared/error', notice: 'You don\'t belong to that account', status: :forbidden
      end
    end

    def user_owns_account!
      if current_user != @account.owner
        render 'shared/error', notice: 'You don\'t own that account', status: :forbidden
      end
    end
end
