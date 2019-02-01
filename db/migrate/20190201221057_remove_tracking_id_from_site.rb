class RemoveTrackingIdFromSite < ActiveRecord::Migration[5.1]
  def change
    remove_column :sites, :tracking_id
  end
end
