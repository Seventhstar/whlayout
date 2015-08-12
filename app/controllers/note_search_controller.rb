include ParseHelper

class NoteSearchController < ApplicationController

	def index
		@items = Array.new()
		#if params[:search]!=nil && params[:search]!=""
			#if params[:search].length >2
			@items = get_prices(params[:search], params[:test])
			p "@items.count:"+@items.count.to_s
			@cathegory = params[:search_category]
			@categories = SearchCategory.order(:name)
			#end
		#end
		
	end




end
