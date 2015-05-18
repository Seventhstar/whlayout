class CreateWhouses < ActiveRecord::Migration
  def change
    create_table :whouses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
