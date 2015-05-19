class AjaxController < ApplicationController

  def add_lay_el
   if params[:layout_element][:layout_id] 
      layout_element = LayoutElement.new
      layout_element.layout_id = params[:layout_element][:layout_id]
      layout_element.element_id = params[:layout_element][:element_id]
      layout_element.save	
   end
	render :nothing => true
   end



end