class LayoutElement < ActiveRecord::Base
  belongs_to :layout
  belongs_to :element, class_name: "Element"

end
