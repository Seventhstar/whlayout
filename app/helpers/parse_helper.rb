require 'open-uri'
require 'nokogiri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


module ParseHelper

  def detail_from_link(link,css, css2, cookie = nil)
    #page = Nokogiri::HTML(open(link))
    
    if cookie
      catch (:done) do
        #p link
        pg = open(link.gsub('//','/').gsub(':/','://'),'Cookie' => cookie)
      end
    else
      pg = open(link)
    end

    return "" if pg.nil? || pg.status[1]!='OK' 
    page = Nokogiri::HTML(pg)

    detail = page.css(css)
    detail = detail.empty? ? page.css(css2) : detail
    detail = detail.text.gsub(/Срок окончания гарантии:/,'')
    detail = detail.gsub(/Гарантия:/,'')
    detail
  end


  def parse_all( url, param_hash, site,name, count=0 )

    #p "site: " + site+ ", param_hash: " + param_hash.to_s
    if param_hash[:cookie]
      pg = open(url,'Cookie' => param_hash[:cookie])
    else
      p url
      begin
        pg = open(url)  
      rescue OpenURI::HTTPError => error
          pg = error.io
          p pg.status
      rescue Net::ReadTimeout => error
         pg = error.io
         p pg.status
      end
      
    end

    showings = {}
    return if pg.status[1]!='OK' 

    # if responde status 200 OK
    p "site: "+ site

    page = Nokogiri::HTML(pg)
    page.encoding ='utf-8'
    
    ind=0
    items = page.css(param_hash[:items])
    items.each do |item|

      ind=ind+1
      break if ind>count && count>0

      if param_hash[:enabled].nil? || item.css(param_hash[:enabled]).empty?

      if param_hash[:title].class.to_s == 'String'
        title = item.css(param_hash[:title])
        title = item.css(param_hash[:href]) if title.empty?
      else
        title = item.css(param_hash[:title][:css])

        #add = item.css(param_hash[:title][:add])
        #p add, add.empty?
        #title = add.empty? ? title : title+add.attr('title') 
        #title = title.text+add.attr('title').text if !add.empty?
        next if title.empty?

      end
        #p title.text,item.css(param_hash[:enabled])
        
      
      link = title.attr('href')
      
      
      link = item.css(param_hash[:href]).attr('href') if link.nil?
      link = item.css(param_hash[:href]).attr('title') if link.nil?
      #p link.class
      link = param_hash[:link_pref].nil? ? link : param_hash[:link_pref] + link

      
      price = item.css(param_hash[:price])

      if price.count>1 
        price = price[0]
      end

      price = price.text.gsub(/([  ])/, '').sub(/ /,'').to_i

      detail = item.css(param_hash[:detail]).text
      
      case param_hash[:id][:method]
      when 'title' 
        id = title.attr(param_hash[:id][:field]).text.to_i
      when 'link'  
        id = link.split('/').last.to_i
      when 'field'
        #p param_hash[:id][:field]
        id = item.attr(param_hash[:id][:field]).split(param_hash[:id][:split]).last.to_i
      when 'css'
        id = item.css(param_hash[:id][:css]).text.split(param_hash[:id][:css]).last.to_i

      end

      link = link.text if link.class==Nokogiri::XML::Attr
      #p link,link.class, link.class==Nokogiri::XML::Attr
      hash_params = { link: link.gsub('//','/').gsub(':/','://'), title: title, price: price, detail: detail, warranty: '', site: site}
      if param_hash[:title].class.to_s == 'String'
        hash_params[:title] = title.text    
      elsif !param_hash[:title][:field].nil? && (param_hash[:title][:field].include? '+')
        hash_params[:title] = title.text + ' '+hash_params[:detail] 
      else
        hash_params[:title] = hash_params[:detail]
      end

      if !name.nil? && !name.empty?
        words = name.split(',')
        c = words.any? {|word| hash_params[:title].downcase.include?(word.downcase)}
        next if !c
      end

      

      if !param_hash[:warranty].nil?
        case param_hash[:warranty][:method]
        when 'page' # гарантия видна только на странице товара
          warranty = detail_from_link(link,param_hash[:warranty][:css],'.prop :contains("арантии")',param_hash[:cookie])
        when 'last' # последнее совпадение
          warranty = item.css(param_hash[:warranty][:css])
          warranty = warranty.last.next_sibling.text
        when 'split'
          warranty = item.css(param_hash[:warranty][:css]).text.split(param_hash[:warranty][:split]).last
        when 'sub' # как подстрока 
          warranty = item.css(param_hash[:warranty][:css]).text
          warranty = warranty.sub(param_hash[:warranty][:sub],'').strip
        end
        hash_params[:warranty] = warranty
      end

      showings.store( price*10000000 + id, hash_params)
      end
    end
    p 'showings.count:'+showings.count.to_s
    showings
  end 


  def get_params(site_name)

    case site_name
    when 'citilink'        
     params = {:items => ".content .item", 
      :id => {:method => 'link', :field=>'last'},
      :title => '.l a',
      :link_pref => 'http://www.citilink.ru',
      :detail => '.descr',
      :price => '.r .price',
      :cookie => 'forceOldSite=1',
      :warranty => {:css=>'.prop :contains("Гарантия")',:method=>'page'} }

    when 'ulmart'

     params = {:items => ".b-products__list .b-box__i", 
      :enabled => 'a.btn.disabled',
      :id => {:method => 'link', :field=>'last'},
      :title => {:css=> '.b-product__title', :field =>'detail'},
      :link_pref => 'http://discount.ulmart.ru',
      :detail => '.b-product__descr',
      :href => '.b-product__title .js-gtm-product-click',
      :price => '.b-price__num',
      :warranty => {:css=>'.b-product__warranty', :sub => '/Гарантия/',:method=>'sub'} }
    when 'club.foto.ru'

     params ={:items => ".lot_row .node", 
      :id => {:method => 'title', :field=>'rel'},
      :title => '.row_name_first .adv_link',
      :href => '.adv_link',
      :link_pref => 'http://club.foto.ru',
      :price => '.cost',
      :warranty => {:css=>'.row_name',:method=>'last'} }
    when 'dns'
     params ={:items => ".ec-price-item", 
      :id => {:method => 'link', :field=>'last'},
      :title => {:css=> '.ec-price-item-link', :field =>'title+detail', :contains=> ''},
      :link_pref => 'http://www.dns-shop.ru',
      :detail => '.spec',
      :href => '.ec-price-item-link',
      :price => '.price_g',
      :cookie => 'city_path=spb',
      :warranty => {:css=>'.guarantee',:method=>'page'} }
    when 'onlinetrade'

     params ={:items => ".category_card__container", 
      :id => {method: 'field', field: 'id', split: '_' },
      :title => '.h3 a',
      :link_pref => 'http://spb.onlinetrade.ru',
      :detail => '.category_card__item_data__text',
      :href => '.h3 a',
      :price => '.price_span',
      :warranty => {:css=>'.category_card__codes_area span',:method=>'split', split: ':'} }

    when 'xcomspb'
      params = {:items => ".item", 
                :id => {method: 'css',css: '.center', split: '_' },
                :title => {:css=> 'a', :field =>'detail'},#{css:'.desc', add: 'a'},
                #:link_pref => 'http://www.xcomspb.ru/',
                :detail => '.desc',
                :href => 'a',
                :price => '.cost-buy strong'}

    when 'yandex'

             params = {:items => ".snippet-card", 
                :id => {method: 'css',css: '.center', split: '_' },
                :title => {:css=> '.snippet-card__header-text', :field =>'detail'},#{css:'.desc', add: 'a'},
                #:link_pref => 'http://www.xcomspb.ru/',
                :detail => '.snippet-card__header-text',
                :href => '.snippet-card__header-link',
                :price => '.snippet-card__price',
                #:cookie => 'city_path=spb',
                #:warranty => {:css=>'.category_card__codes_area span',:method=>'sub', sub: 'Официальная гарантия'} 
                
              }
  end
  params 
end

  def get_prices(name, test = false)
    
    if test && !Rails.env.production?
      page_citilink   = "D:/www/ruby/disc_ex/citi_note.html"
      page_ulmart   = "D:/www/ruby/disc_ex/game_ul.html"
      page_ulmart2  = "D:/www/ruby/disc_ex/univ_ul.html"
      page_club_photo_ru  = "http://club.foto.ru/secondhand2/?cat=0&man%5B%5D=0&name=&system_lens=4208&city%5B%5D=3104&state=0&cost1=3000&cost2=40000"
      page_club_photo_ru2 = "http://club.foto.ru/secondhand2/?cat=0&man%5B0%5D=0&name=&system_lens=4208&city%5B0%5D=3104&state=0&cost1=3000&cost2=40000&page=2#listStart"
      #page_ulmart2   = "http://discount.ulmart.ru/discount/notebooks_5202_10454?sort=7&viewType=1&rec=true&filters=346%3A1201%3B347%3A18720%2C8712%3B644%3A2374%2C2376%3B5472%3A20331%2C95965%3B189910%3A249219%2C249218%3B189922%3A249244&brands=&warranties=&shops=&labels=&available=false&reserved=false&suborder=false&superPrice=false&specOffers=false"
      page_ulmart_photo = 'http://discount.ulmart.ru/discount/lens?sort=7&viewType=1&rec=true'
      page_ulmart_photo2 = 'http://discount.ulmart.ru/discount/digital_camera?sort=7&viewType=1&rec=true'
    else
      page_citilink   = "http://www.citilink.ru/discount/mobile/notebooks/?available=&multy[]=2805_3&multy[]=2807_3&?available=&multy[]=2805_3&multy[]=2807_3&"
      page_ulmart   = "http://discount.ulmart.ru/discount/notebooks_5202_10444?sort=0&viewType=1&rec=true&extended=true"
      page_ulmart2  = "http://discount.ulmart.ru/discount/notebooks_5202_10454?sort=7&viewType=1&rec=false&filters=347%3A18720%2C8712%3B644%3A2374%2C2376%3B5472%3A20331%3B190722%3A250070%2C250071%3B190731%3A250092&brands=3567%2C120%2C20%2C210%2C42%2C4515&warranties=&shops=&labels=&available=false&reserved=false&suborder=false&superPrice=false&specOffers=false"
      page_club_photo_ru  = "http://club.foto.ru/secondhand2/?cat=0&man%5B%5D=0&name=&system_lens=4208&city%5B%5D=3104&state=0&cost1=3000&cost2=40000"
      page_club_photo_ru2   = "http://club.foto.ru/secondhand2/?cat=0&man%5B0%5D=0&name=&system_lens=4208&city%5B0%5D=3104&state=0&cost1=3000&cost2=40000&page=2#listStart"
      page_ulmart_photo = 'http://discount.ulmart.ru/discount/lens?sort=7&viewType=1&rec=true'
      page_ulmart_photo2 = 'http://discount.ulmart.ru/discount/digital_camera?sort=7&viewType=1&rec=true'

      page_ulmart_mb = 'http://www.ulmart.ru/discount/motherboards_for_intel?sort=7&viewType=1&rec=true&filters=197%3A46927%3B189751%3A249449%2C249448%3B189763%3A249474&brands=&warranties=&shops=&labels=&available=false&reserved=false&suborder=false&superPrice=false&specOffers=false'
      page_citilink_mb = 'http://www.citilink.ru/discount/computers_and_notebooks/parts/motherboards/'
    end   

    showings ={}
    if params[:search_category] && params[:search_category]!='0'
      cat = SearchCategory.find(params[:search_category])
      p "cat.urls.count:" + cat.urls.count.to_s
      #if cat.urls
      current_user.update_attributes(:progress => 'start')
        i =0 
        cat.urls.each do |url| 

          p = get_params(url.site.name)
          sh = parse_all(url.url,p,url.site.name,name)
          showings = showings.merge(sh) if !sh.nil?
          #case url.site.name
          #when 'citilink'
          #  showings = showings.merge(parse_citilink(url.url,name))
          #when 'ulmart'
          #  showings = showings.merge(parse_ulmart(url.url,name))
          #when 'club.foto.ru'
          #  showings = showings.merge(parse_club_photo_ru(url.url,name))
          #when 'dns'
          #  showings = showings.merge(parse_dns(url.url,name))
          #when 'onlinetrade'
          #  showings = showings.merge(parse_onlinetrade(url.url,name))
          #when 'xcomspb'
          #  showings = showings.merge(parse_xcom(url.url,name))
          #when 'yandex'
          #  showings = showings.merge(parse_yamarket(url.url,name,5))
          #end
          i=i+1
          #current_user.update_attributes(:progress => (i.to_s+". "+url.site.name))
      end
      #end
      #current_user.update_attributes(:progress => 'done')
    end
    showings = showings.sort
  
  end

end