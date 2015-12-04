class AddPToSearchSite < ActiveRecord::Migration
  def change
    add_column :search_sites, :items, :string
    add_column :search_sites, :id_method, :string
    add_column :search_sites, :id_field, :string
    add_column :search_sites, :id_split, :string
    add_column :search_sites, :title, :string
    add_column :search_sites, :link_pref, :string
    add_column :search_sites, :detail, :string
    add_column :search_sites, :href, :string
    add_column :search_sites, :price, :string
    add_column :search_sites, :cookie, :string
    add_column :search_sites, :warranty_css, :string
    add_column :search_sites, :warranty_method, :string
    add_column :search_sites, :warranty_split, :string
  end
end
