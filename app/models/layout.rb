class Layout < ActiveRecord::Base
    has_many :layout_elements
    #has_many :elements, through: :layout_elements
    has_many :elements, :through => :layout_elements, :source => "element"
end
