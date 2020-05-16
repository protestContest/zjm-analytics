class AccountInvitesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_account_invite, only: [:show, :accept, :reject, :destroy]
  before_action :authenticate_user!, unless: :is_public_with_token

  before_action :user_owns_account!, only: [:create]
  before_action :no_invite_pending!, only: [:create]
  before_action :has_token!, only: [:accept, :reject, :show]

  def new
    @invite = AccountInvite.new
  end

  def create
    @invite = AccountInvite.new(account_invite_params)

    respond_to do |format|
      if @invite.save
        # AccountInviteMailer.with(transfer: @invite).transfer_request.deliver_later
        format.html { redirect_back fallback_location: [current_user, @invite.account] }
        format.json { render :show, status: :created, location: [current_user, @invite.account] }
      else
        format.html { render :new }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def accept
    respond_to do |format|
      if @invite.accept!
        @invite.account.users << current_user
        @invite.account.save
        format.html { redirect_to [current_user, @invite.account] }
      else
        format.html { render 'shared/error', status: :forbidden }
      end
    end
  end

  def reject
    respond_to do |format|
      if @invite.reject!
        format.html { redirect_to @invite }
      else
        format.html { render 'shared/error', status: :forbidden }
      end
    end
  end

  private

    def set_account_invite
      @invite = AccountInvite.find(params[:id])
    end

    def account_invite_params
      params.require(:account_invite).permit(:account_id, :invite_email)
      account = Account.find(params[:account_invite][:account_id])

      return {
        account: account,
        invite_email: params[:account_invite][:invite_email]
      }
    end

    def account_invite_response_param
      params.require(:account_invite).permit(:response)
    end

    def user_owns_account!
      account = Account.find(params[:account_invite][:account_id])
      if account.nil? || account.owner != current_user
        render 'shared/error', notice: 'You cant\'t invite to other accounts', status: :forbidden
      end
    end

    def no_invite_pending!
      account = Account.find(params[:account_invite][:account_id])
      invite = AccountInvite.where(account: account, invite_email: params[:account_invite][:invite_email], response: 'pending').first
      if !invite.nil?
        render 'shared/error', notice: 'This account is already pending invite', status: :forbidden
      end
    end

    def is_public_with_token
      ['reject', 'show'].include?(params[:action]) && has_token
    end

    def has_token
      @is_responding = false
      if ['accept', 'reject', 'show'].include? params[:action]
        if params[:response_token] == @invite.response_token
          @is_responding = true
        end
      end

      return @is_responding
    end

    def has_token!
      if !has_token
        render 'shared/error', notice: 'You can\'t do that', status: :forbidden
      end
    end
end
