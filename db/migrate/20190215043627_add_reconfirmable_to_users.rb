class AddReconfirmableToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :unconfirmed_email, :string
    add_index :users, :confirmation_token, unique: true
    User.update_all confirmed_at: DateTime.now
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    remove_columns :users, :unconfirmed_email # Only if using reconfirmable
  end
end
