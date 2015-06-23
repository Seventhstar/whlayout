class CreateSearchSites < ActiveRecord::Migration
  def change
    create_table :search_sites do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
