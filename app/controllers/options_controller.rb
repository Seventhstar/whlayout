class OptionsController < ApplicationController

 def edit

    if params[:options_page]
      @page_render = params[:options_page]+"/"+params[:options_page]
      @page_data = params[:options_page]
    else 
      @page_render = "elements/elements"
      @page_data = "elements"
    end

    @items = params[:options_page].classify.constantize.order(:name)
    @item = params[:options_page].classify.constantize.new
    

  end


end
