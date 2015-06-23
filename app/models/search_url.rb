class SearchUrl < ActiveRecord::Base
  belongs_to :site, class_name: "SearchSite", foreign_key: :search_site_id
  belongs_to :category, class_name: "SearchCategory", foreign_key: :search_category_id


  def parents_count
    0
  end


end
