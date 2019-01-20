class AddLocationToHit < ActiveRecord::Migration[5.1]
  def change
    add_column :hits, :location, :string
  end
end
