class AddRefererToHits < ActiveRecord::Migration[5.2]
  def change
    add_column :hits, :referer, :string
  end
end
