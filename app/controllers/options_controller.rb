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
    when "whouses"
      @items = Whouse.order(:name)
      @item  = Whouse.new
    when "search_categories"
      @items = SearchCategory.order(:name)
      @item  = SearchCategory.new
    when "search_sites"
      @items  = SearchSite.order(:name)
      @item   = SearchSite.new
    else

      puts "You gave me #{a} -- I have no idea what to do with that."
    end

  end


end
