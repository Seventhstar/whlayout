class WhouseElement < ActiveRecord::Base
  belongs_to :whouse
  belongs_to :element, class_name: "Element"

  def element_name
    element.try(:name)
  end


end
