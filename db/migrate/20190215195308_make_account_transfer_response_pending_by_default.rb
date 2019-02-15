class MakeAccountTransferResponsePendingByDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :account_transfers, :response, :integer, :default => 0
  end
end
