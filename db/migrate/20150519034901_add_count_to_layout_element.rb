class AddCountToLayoutElement < ActiveRecord::Migration
  def change
    add_column :layout_elements, :count, :integer
  end
end
