class AddAccountReferenceToSites < ActiveRecord::Migration[5.1]
  def change
    add_reference :sites, :account, foreign_key: true

    Site.find_each do |site|
      site.account_id = User.find(site.user_id).owned_accounts.first.id
      site.save!
    end

    remove_reference :sites, :user, foreign_key: true
  end
end
