require 'open-uri'
require 'nokogiri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


module ParseHelper

  def detail_from_link(link,css, css2, cookie = nil)
    #page = Nokogiri::HTML(open(link))
    p link if link.index('.dns.')!=nil
    if cookie
      #catch (:done) do
      
        _link = link.gsub('//','/').gsub(':/','://')

      begin
        pg = open(_link,'Cookie' => cookie)
      rescue
        puts 'ошибка открытия link'
        return nil
      end
        #return
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

  #

  def parse_all( url, site, name, count=0 )

    param_hash = get_params(site)
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
        
      
      link_pref = 'http://'+url.split('//')[1].split('/')[0]
      #p "link_pref: "+link_pref

      link = title.attr('href')
      link = item.css(param_hash[:href]).attr('href') if link.nil?
      link = item.css(param_hash[:href]).attr('title') if link.nil?
      #link = param_hash[:link_pref].nil? ? link : param_hash[:link_pref] + link
      link = param_hash[:link_pref].nil? ? link.text : link_pref + link
      p link
      
      price = item.css(param_hash[:price])
      price = price[0] if price.count>1
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
         words=add_words=sub_words=nil
         pp = name.gsub(/(&|-)/){'%'+$1}.split('%')
         pp.each do |cp|
          case cp[0]
          when '&' # 
            add_words = cp[1..-1].split(',') # слова которые также должны быть в наименовании
          when '-'
            sub_words = cp[1..-1].split(',') # слова которых не должно быть 
          else
            words = cp.split(',') # слова которые должны быть в наименовании
          end      
        end
        #p "words: " + words.to_s  + ", add_words: " + add_words.to_s + ", sub_words: " +sub_words.to_s     
        next if !words.any? {|word| hash_params[:title].downcase.include?(word.downcase)} if ((!words.nil?) && (words.count>0))
        next if !add_words.any? {|word| hash_params[:title].downcase.include?(word.downcase)} if !add_words.nil?
        next if sub_words.any? {|word| hash_params[:title].downcase.include?(word.downcase)} if !sub_words.nil?
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
                :title => {:css=> 'a', :field =>'detail + title'},#{css:'.desc', add: 'a'},
                #:link_pref => 'http://www.xcomspb.ru/',
                :detail => '.desc',
                :href => 'a',
                :price => '.cost-buy strong'}

    when 'dh'
      params ={:items => ".cfds_category_row", 
      :id => {:method => 'link', :field=>'last'},#:title => {:css=> '.ipsType_subtitle a', :field =>'detail + title'}, #'a',
      
      :title => '.ipsType_subtitle a',
      :detail => '.desc',
      :href => '.ipsType_subtitle a',
      :price => '.priceBadge',
      :warranty => {:css=>'.ipsList_data :contains("Город") .row_data',:method=>'page'} 
    }                 

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

    showings ={}
    if params[:search_category] && params[:search_category]!='0'
      cat = SearchCategory.find(params[:search_category])
      p "cat.urls.count:" + cat.urls.count.to_s

      current_user.update_attributes(:progress => 'start')
        i =0 
        cat.urls.where(disabled: false).each do |url| 
          sh = parse_all(url.url,url.site.name,name)
          showings = showings.merge(sh) if !sh.nil?
          i=i+1
      end
    end
    showings = showings.sort
  
  end

end