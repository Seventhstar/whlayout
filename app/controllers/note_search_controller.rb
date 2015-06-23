class NoteSearchController < ApplicationController

require 'open-uri'
require 'nokogiri'


	def index
		@items = Array.new()
		#if params[:search]!=nil && params[:search]!=""
			#if params[:search].length >2
			@items = get_prices(params[:search], params[:test])
			@cathegory = params[:search_category]
			@categories = SearchCategory.order(:name)
			#end
		#end
		
	end

	def detail_from_link(link,css, css2)
		page = Nokogiri::HTML(open(link))
		detail = page.css(css)
		detail = detail.empty? ? page.css(css2) : detail
		detail = detail.text.gsub(/Срок окончания гарантии:/,'')
		detail = detail.gsub(/Гарантия:/,'')
		detail
	end


	def parse_all( url, param_hash, site )

		page = Nokogiri::HTML(open(url))
		page.encoding ='utf-8'
		showings = {}
		#p page
		items = page.css(param_hash[:items])
		p items.count
		items.each do |item|

  		  if param_hash[:enabled].nil? || item.css(param_hash[:enabled]).empty?
		    title = item.css(param_hash[:title])
			
			link  = title.attr('href')
			if link.nil?
			  href = title.css('.must_be_href')
			  link  = href.attr('title').text 
			end
			link = param_hash[:link_pref] + link

			price = item.css(param_hash[:price]).text.gsub(/([  ])/, '').sub(/ /,'').to_i
			detail = item.css(param_hash[:detail]).text
			
			case param_hash[:id][:method]
			when 'title' 
				id = title.attr(param_hash[:id][:field]).text.to_i
				
			when 'link'  
				id = link.split('/').last.to_i
				
			end
			#puts "id",title

			title = title.text		

			case param_hash[:warranty][:method]
			when 'page'
				warranty = detail_from_link(link,param_hash[:warranty],'.prop :contains("арантии")')
				puts warranty
			when 'last'
				warranty = item.css(param_hash[:warranty][:css])
				warranty = warranty.last.next_sibling.text
			when 'sub'
				warranty = item.css(param_hash[:warranty][:css]).text
				warranty = warranty.sub(param_hash[:warranty][:sub],'').strip
			end

			
			showings.store( price*10000000 + id,{ link: link, title: title, price: price, detail: detail + id.to_s, warranty: warranty, site: site} )
			#p showings.count
		  end
		end
		showings
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
			link  = "http://www.citilink.ru"+title.attr('href').text
			title = title.text
			price = item.css('.r .price').text.sub(/ /, '').to_i
			detail = item.css('.descr').text

			warranty = detail_from_link(link,'.prop :contains("Гарантия")','.prop :contains("арантии")')
			showings.store( price,{ link: link, title: title, price: price, detail: detail, warranty: warranty, site: 'citilink'} )
		end
		showings
	end

	def parse_ulmart(url)
		showings = parse_all(url,
							 {:items => ".b-products__list .b-box__i", 
							  :enabled => 'a.btn.disabled',
							  :id => {:method => 'link', :field=>'last'},
							  :title => '.b-product__title',
							  :href => '.must_be_href',
							  :link_pref => 'http://discount.ulmart.ru',
							  :price => '.b-price__num',
							  :warranty => {:css=>'.b-product__warranty', :sub => '/Гарантия/',:method=>'sub'} },'ulmart')
	end


	def parse_club_photo_ru(url)

		showings = parse_all(url,
							 {:items => ".lot_row .node", 
							  :id => {:method => 'title', :field=>'rel'},
							  :title => '.row_name_first a',
							  :href => '.adv_link',
							  :link_pref => 'http://club.foto.ru',
							  :price => '.cost',
							  :warranty => {:css=>'.row_name',:method=>'last'} },'club.foto.ru')		#:contains("азмещено")
	end

	def get_prices(name, test = false)
		
		if test && !Rails.env.production?
			page_citilink 	= "D:/www/ruby/disc_ex/citi_note.html"
			page_ulmart		= "D:/www/ruby/disc_ex/game_ul.html"
			page_ulmart2	= "D:/www/ruby/disc_ex/univ_ul.html"
			page_club_photo_ru 	= "http://club.foto.ru/secondhand2/?cat=0&man%5B%5D=0&name=&system_lens=4208&city%5B%5D=3104&state=0&cost1=3000&cost2=40000"
			page_club_photo_ru2 = "http://club.foto.ru/secondhand2/?cat=0&man%5B0%5D=0&name=&system_lens=4208&city%5B0%5D=3104&state=0&cost1=3000&cost2=40000&page=2#listStart"
			#page_ulmart2 	= "http://discount.ulmart.ru/discount/notebooks_5202_10454?sort=7&viewType=1&rec=true&filters=346%3A1201%3B347%3A18720%2C8712%3B644%3A2374%2C2376%3B5472%3A20331%2C95965%3B189910%3A249219%2C249218%3B189922%3A249244&brands=&warranties=&shops=&labels=&available=false&reserved=false&suborder=false&superPrice=false&specOffers=false"
			page_ulmart_photo = 'http://discount.ulmart.ru/discount/lens?sort=7&viewType=1&rec=true'
			page_ulmart_photo2 = 'http://discount.ulmart.ru/discount/digital_camera?sort=7&viewType=1&rec=true'
		else
			page_citilink 	= "http://www.citilink.ru/discount/mobile/notebooks/?available=&multy[]=2805_3&multy[]=2807_3&?available=&multy[]=2805_3&multy[]=2807_3&"
			page_ulmart 	= "http://discount.ulmart.ru/discount/notebooks_5202_10444?sort=0&viewType=1&rec=true&extended=true"
			page_ulmart2 	= "http://discount.ulmart.ru/discount/notebooks_5202_10454?sort=7&viewType=1&rec=true&filters=346%3A1201%3B347%3A18720%2C8712%3B644%3A2374%2C2376%3B5472%3A20331%2C95965%3B189910%3A249219%2C249218%3B189922%3A249244&brands=&warranties=&shops=&labels=&available=false&reserved=false&suborder=false&superPrice=false&specOffers=false"
			page_club_photo_ru 	= "http://club.foto.ru/secondhand2/?cat=0&man%5B%5D=0&name=&system_lens=4208&city%5B%5D=3104&state=0&cost1=3000&cost2=40000"
			page_club_photo_ru2 	= "http://club.foto.ru/secondhand2/?cat=0&man%5B0%5D=0&name=&system_lens=4208&city%5B0%5D=3104&state=0&cost1=3000&cost2=40000&page=2#listStart"
			page_ulmart_photo = 'http://discount.ulmart.ru/discount/lens?sort=7&viewType=1&rec=true'
			page_ulmart_photo2 = 'http://discount.ulmart.ru/discount/digital_camera?sort=7&viewType=1&rec=true'

			page_ulmart_mb = 'http://www.ulmart.ru/discount/motherboards_for_intel?sort=7&viewType=1&rec=true&filters=197%3A46927%3B189751%3A249449%2C249448%3B189763%3A249474&brands=&warranties=&shops=&labels=&available=false&reserved=false&suborder=false&superPrice=false&specOffers=false'
			page_citilink_mb = 'http://www.citilink.ru/discount/computers_and_notebooks/parts/motherboards/'
		end		

		showings ={}
		if params[:search_category] && params[:search_category]!='0'
			cat = SearchCategory.find(params[:search_category])
			p cat.urls.count
			cat.urls.each do |url|
				case url.site.name
				when 'citilink'
					showings = showings.merge(parse_citilink(url.url))
				when 'ulmart'
					showings = showings.merge(parse_ulmart(url.url))
				when 'club.foto.ru'
					showings = showings.merge(parse_club_photo_ru(url.url))
				end
			end
		end
		#case params[:search_category]

		#when '1' #note
		#	showings = parse_citilink(page_citilink)
		#	showings = showings.merge(parse_ulmart(page_ulmart))
		#	showings = showings.merge(parse_ulmart(page_ulmart2))
		#when '2' #foto
		##	showings = parse_club_photo_ru(page_club_photo_ru)
		#	showings = showings.merge(parse_club_photo_ru(page_club_photo_ru2))
	#		showings = showings.merge(parse_ulmart(page_ulmart_photo))
	#		showings = showings.merge(parse_ulmart(page_ulmart_photo2))
	#	end


		#puts showings
		showings = showings.sort
		
	end


end
