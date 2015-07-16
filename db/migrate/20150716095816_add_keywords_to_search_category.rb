class AddKeywordsToSearchCategory < ActiveRecord::Migration
  def change
    add_column :search_categories, :keywords, :string
  end
end
