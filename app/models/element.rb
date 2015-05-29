class Element < ActiveRecord::Base
   has_many :layout_elements
   has_many :whouse_elements, dependent: :destroy
   has_many :layouts, through: :layout_elements
   has_many :whouses, through: :whouse_elements

  attr_accessor :parents_count
  
  def parents_count
    self.try(:layouts).count
  end

end
