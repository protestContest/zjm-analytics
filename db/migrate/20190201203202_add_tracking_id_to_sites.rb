class AddTrackingIdToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :tracking_id, :integer
    add_index :sites, :tracking_id
  end
end
