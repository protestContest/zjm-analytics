class AccountTransferMailer < ApplicationMailer
  def transfer_request
    transfer = params[:transfer]
    @account = transfer.account
    @transfer_response_url = edit_account_transfer_url(transfer, response_token: transfer.response_token)
    mail(to: transfer.target_owner, subject: 'Account Transfer Request')
  end
end
