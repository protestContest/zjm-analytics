class CreateAccountTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :account_transfers do |t|
      t.references :account, foreign_key: true
      t.references :original_owner, foreign_key: { to_table: :users }
      t.references :target_owner, foreign_key: { to_table: :users }
      t.integer :response
      t.datetime :responded_at
      t.string :response_token

      t.index :response_token

      t.timestamps
    end
  end
end
