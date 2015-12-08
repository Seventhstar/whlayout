class AddEnToSearchSite < ActiveRecord::Migration
  def change
    add_column :search_sites, :disabled, :string
  end
end
