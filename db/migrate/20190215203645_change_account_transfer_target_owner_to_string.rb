class ChangeAccountTransferTargetOwnerToString < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :account_transfers, column: :target_owner_id
    rename_column :account_transfers, :target_owner_id, :target_owner
    change_column :account_transfers, :target_owner, :string
  end
end
