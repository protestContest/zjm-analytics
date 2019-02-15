class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
