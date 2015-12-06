class AddTitleFieldToSearchSite < ActiveRecord::Migration
  def change
    add_column :search_sites, :title_field, :string
  end
end
