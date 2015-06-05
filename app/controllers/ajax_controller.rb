class AjaxController < ApplicationController

  def add_lay_el
   if params[:lay_el][:layout_id] 
      layout_element = LayoutElement.new
      layout_element.layout_id 	= params[:lay_el][:layout_id]
      layout_element.element_id = params[:lay_el][:element_id]
      layout_element.count 		= params[:lay_el][:count]
      layout_element.save	
   end
	render :nothing => true
   end

   def del_lay_el
	  if params[:el_id] 
         le = LayoutElement.find(params[:el_id]).destroy
       end
  	render :nothing => true
   end

  def add_wh_el
    puts "we in add_wh_el"
   if params[:wh_el][:element_id]
      w_el = WhouseElement.new
      w_el.whouse_id 	= params[:wh_el][:whouse_id]
      w_el.element_id = params[:wh_el][:element_id]
      w_el.count 		= params[:wh_el][:count]
      w_el.save	
  else
      #puts "params^ "+params
      w_el = WhouseElement.new
      w_el.whouse_id  = params[:whouse_id]
      el = Element.where(name: params[:search]).first_or_create
      w_el.element_id = el.id
      w_el.count    = params[:wh_el][:count]
      w_el.save 
   end
	  render :nothing => true
   end

   def del_wh_el
	  if params[:el_id] 
         le = WhouseElement.find(params[:el_id]).destroy
       end
  	render :nothing => true
   end

   def upd_param
       puts params
  	render :nothing => true
   end

end