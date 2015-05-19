class Whouse < ActiveRecord::Base
    has_many :whouse_elements
    has_many :elements, :through => :whouse_elements, :source => "element"

  attr_accessor :parents_count
  
  def parents_count
    #self.try(:elements).count
    0
  end

end
