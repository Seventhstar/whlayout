class Element < ActiveRecord::Base
   has_many :layouts, through: :layout_elements
end
