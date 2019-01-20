class CreateHits < ActiveRecord::Migration[5.1]
  def change
    create_table :hits do |t|
      t.string :hit_type
      t.string :language
      t.string :encoding
      t.string :title
      t.integer :color_depth
      t.string :screen_res
      t.string :viewport
      t.string :tracking_id
      t.string :client_id
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end
