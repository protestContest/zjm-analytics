class CreateAccountsUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :accounts, :users do |t|
      t.index :account_id
      t.index :user_id
    end
  end
end
