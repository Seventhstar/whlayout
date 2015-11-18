class AddDisabledToSearchUrls < ActiveRecord::Migration
  def change
    add_column :search_urls, :disabled, :boolean, default: false
  end
end
