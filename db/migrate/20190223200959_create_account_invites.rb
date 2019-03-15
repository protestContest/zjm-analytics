class CreateAccountInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :account_invites do |t|
      t.string :invite_email
      t.references :account, foreign_key: true
      t.integer :response
      t.datetime :responded_at
      t.string :response_token

      t.timestamps
    end
  end
end
