class GoodsSearchController < ApplicationController

require 'open-uri'
require 'nokogiri'


	def index
		@items = Array.new()
		if params[:search]!=nil && params[:search]!=""
			if params[:search].length >2
				@items = get_prices(params[:search], params[:test])
			end
		end
		
	end

	def get_prices(name, test = false)
		
		if test
			#page_ebay = "H:/temp/max1771_eBay.html"
			#page_ali = "H:/temp/max1771_AliExpress.com.html"
			page_ebay = "H:/temp/pic16f_ eBay.html"
			page_ali = "H:/temp/pic16f_AliExpress.com.html"
		else
			page_ebay = "http://www.ebay.com/sch/i.html?_from=R40&_trksid=p2055119.m570.l1313.TR7.TRC1.A0.H0.Xds3231.TRS2&_sacat=0&_nkw="+name
			page_ali ="http://www.aliexpress.com/wholesale?shipCountry=RU&isFreeShip=y&SortType=price_asc&SearchText="+name
		end		

		page = Nokogiri::HTML(open(page_ebay))

		news_links = page.css("#ListViewInner .sresult")
		showings = {}

		news_links.each do |item|
		 
		 title = item.css('.lvtitle a').attr('data-mtdes')
		 title ||= item.css('.lvtitle a')[0]
		 title = title.text

		 lot_count = title.split('PCS')[0].to_i
	 	 lot_count = lot_count ==0 ? 1 : lot_count
	 
		 id = item.css('.lvpic').attr('iid').text

		 price  	= item.css('li.lvprice span.bold')[0].text.split('<b>').first.gsub(/\d+|,/).to_a.join('').to_i
		 ship_info = item.css('li.lvshipping span.fee')
		 ship_price = 0
		 if !ship_info.nil?
		    #ship_price = ship_info.count>0 ? ship_info : 0
		    ship_price = ship_info[0]
		    if !ship_price.nil?
		    	ship_price = ship_price.text.split('<b>').first.gsub(/\d+|,/).to_a.join('')
		    end
		 end

		 showings.store( (price + ship_price.to_i)*10000000000000000000 + id.to_i  ,{ id: id, title: title, price: price, lot_count: lot_count, item_price: price / lot_count, ship_price: ship_price, site: 'ebay'} )
		end

		page = Nokogiri::HTML(open(page_ali))

		news_links = page.css("#hs-list-items .list-item") 
		news_links.each do |item|
		 
		 title = item.css('.detail a.history-item.product').attr('title')
		 id = 0
		 price = item.css("span[itemprop='price']").text.split(' ').first.to_i
		 lot_count  = item.css("span.min-order").text.split(' ').first.to_i
		 if lot_count==0 
		 	puts title.text
		 end

		 lot_count = lot_count ==0 ? 1 : lot_count


		 ship_price = 0

		 showings.store( price ,{ id: id, title: title.text, price: price, lot_count: lot_count, item_price: price / lot_count, ship_price: ship_price, site: 'ali'} )
		end
		puts showings[0..4]
		showings = showings.sort
		
	end


end
