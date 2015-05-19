class OptionsController < ApplicationController

 def edit

    if params[:options_page]
      @page_render = params[:options_page]+"/"+params[:options_page]
      @page_data = params[:options_page]
    else 
      @page_render = "elements/elements"
      @page_data = "elements"
    end

    puts params[:options_page]
    case params[:options_page]
    when "elements"
      @items = Element.order(:name)
      @item  = Element.new
    else
      puts "You gave me #{a} -- I have no idea what to do with that."
    end

  end


end
