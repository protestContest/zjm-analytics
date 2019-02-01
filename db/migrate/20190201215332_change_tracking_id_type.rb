class ChangeTrackingIdType < ActiveRecord::Migration[5.1]
  def change
    change_column :sites, :tracking_id, :string
  end
end
