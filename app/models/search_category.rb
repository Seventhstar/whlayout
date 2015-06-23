class SearchCategory < ActiveRecord::Base
  has_many :urls, class_name: "SearchUrl", foreign_key: :search_category_id
  def parents_count
    0
  end

end
