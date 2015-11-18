require 'open-uri'
require 'nokogiri'
include ParseHelper

class UsdController < ApplicationController

	def index
		page_rbc = "http://www.rbc.ru/"
		page = Nokogiri::HTML(open(page_rbc))
		@news_links = page.css(".news-quote .l-row .l-col-140px-main")
		puts @news_links

	end

end
