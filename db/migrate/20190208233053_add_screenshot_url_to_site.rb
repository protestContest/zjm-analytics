class AddScreenshotUrlToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :screenshot_url, :string
  end
end
