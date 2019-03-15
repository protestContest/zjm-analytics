class MakeAccountInviteResponsePendingByDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :account_invites, :response, :integer, :default => 0
  end
end
