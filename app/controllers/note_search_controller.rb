class NoteSearchController < ApplicationController

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

	def parse_citilink(page_citilink)
		page = Nokogiri::HTML(open(page_citilink))
		page.encoding ='utf-8'

		puts page.encoding

		items = page.css(".content .item")
		puts items.count.to_s

		showings = {}

		items.each do |item|

			title = item.css('.l a')	
			link  = title.attr('href').text
			title = title.text
			price = item.css('.r .price').text.sub(/ /, '').to_i
			detail = item.css('.descr').text
			showings.store( price,{ link: link, title: title, price: price, detail: detail, site: 'citilink'} )
		end
		showings
	end

	def parse_ulmart(ulmart_url)

		page = Nokogiri::HTML(open(ulmart_url))

		showings = {}

		items = page.css(".b-products__list .b-box__i")
		items.each do |item|
		 
		 	enabled = item.css('a.btn.disabled').empty? #.nil? ? 1:2
		 	title = item.css('.b-product__title .b-truncate')
			if enabled && !title.empty?
			
			
			link  = title.css('span a').attr('href').text
			title = title.text.strip
			#puts link,title	
			#title = title.text
			price = item.css('.b-price__num').text.sub(/ /,'').strip.to_i
			#puts title,price
			detail = item.css('.b-product__descr').text
			#p detail
		 	showings.store( price,{ link: link, title: detail, price: price.to_s, detail: detail, site: 'ulmart'} )
		 	end
		end
		showings
	end

	def get_prices(name, test = false)
		
		if test
			page_citilink 	= "D:/www/ruby/disc_ex/citi_note.html"
			page_ulmart		= "D:/www/ruby/disc_ex/game_ul.html"
			page_ulmart2 	= "http://discount.ulmart.ru/discount/notebooks_5202_10454?sort=0&viewType=1&rec=true&extended=true"
		else
			page_citilink 	= "http://www.citilink.ru/discount/mobile/notebooks/?available=&multy[]=2805_3&multy[]=2807_3&?available=&multy[]=2805_3&multy[]=2807_3&"
			page_ulmart 	= "http://discount.ulmart.ru/discount/notebooks_5202_10444?sort=0&viewType=1&rec=true&extended=true"
			page_ulmart2 	= "http://discount.ulmart.ru/discount/notebooks_5202_10454?sort=0&viewType=1&rec=true&extended=true"
		end		

		showings = parse_citilink(page_citilink)
		showings = showings.merge(parse_ulmart(page_ulmart))

		#puts showings
		showings = showings.sort
		
	end


end
