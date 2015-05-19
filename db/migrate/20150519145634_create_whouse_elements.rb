class CreateWhouseElements < ActiveRecord::Migration
  def change
    create_table :whouse_elements do |t|
      t.integer :whouse_id
      t.integer :element_id
      t.integer :count
      t.timestamps null: false
    end
  end
end
