class CreateSearchUrls < ActiveRecord::Migration
  def change
    create_table :search_urls do |t|
      t.string :url
      t.integer :search_site_id
      t.integer :search_category_id

      t.timestamps null: false
    end
  end
end
