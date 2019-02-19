# Preview all emails at http://localhost:3000/rails/mailers/account_transfer_mailer
class AccountTransferMailerPreview < ActionMailer::Preview
  def transfer_request
    account = Account.first
    transfer = AccountTransfer.new(account: account, original_owner: account.owner, target_owner: 'test@example.com')
    transfer.save

    AccountTransferMailer.with(transfer: transfer).transfer_request
  end
end
