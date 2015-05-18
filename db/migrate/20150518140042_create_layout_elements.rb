class CreateLayoutElements < ActiveRecord::Migration
  def change
    create_table :layout_elements do |t|
      t.integer :layout_id
      t.integer :element_id

      t.timestamps null: false
    end
  end
end
