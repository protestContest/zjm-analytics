class CreateMailingListSignups < ActiveRecord::Migration[5.2]
  def change
    create_table :mailing_list_signups do |t|
      t.string :email

      t.timestamps
    end
  end
end
