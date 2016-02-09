require 'open-uri'
require 'nokogiri'
require 'openssl'

# устраняет ошибку certificate B: certificate verify failed
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module ParseHelper

  def detail_from_link(link,css, css2, cookie = nil)
    
    _link = link.gsub('//','/').gsub(':/','://')
    begin
      if !cookie.empty?
          response = Net::HTTP.get_response(URI.parse(_link),'Cookie' => cookie)
          pg = open(_link,'Cookie' => cookie)
      else
          response = Net::HTTP.get_response(URI.parse(_link)) 
          pg = open(_link)
      end
    rescue Exception => e
        puts _link, "cookie: " + cookie
        puts 'ошибка открытия link: ',e
        return '# error'
    end

    return "" if pg.nil? || pg.status[1]!='OK' 
    page = Nokogiri::HTML(pg)

    detail = page.css(css)
    detail = detail.empty? ? page.css(css2) : detail
    #p detail.class.to_s
    detail = detail.text if detail.class.to_s != 'String'
    detail = detail.gsub(/Срок окончания гарантии:/,'')
    detail = detail.gsub(/Показать телефон/,'')
    detail = detail.gsub(/Написать сообщение/,'')
    detail = detail.gsub(/Гарантия:/,'')
    detail
  end

  #

  def parse_all( url, site, name, count=0 )

    #param_hash = get_params(site.name)
    begin
      if !site.cookie.nil? && !site.cookie.empty?
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri.request_uri,'Cookie' => site.cookie)
        pg = open(url,'Cookie' => site.cookie)
      else
        pg = open(url)  
      end
    rescue Exception => e
      puts "site: " + site.name,e
      showings = {}
      url = url[0..100]+' ...' if url.length>100
      hash_params = { link: url, title: 'ошибка: '+ url, price: 0, detail:'', warranty: '', site: site.name}
      showings.store( site.id, hash_params)
      return showings
    end

    showings = {}
  
    p "site: "+ site.name

    page = Nokogiri::HTML(pg)
    page.encoding ='utf-8'
    
    ind=0
    items = page.css(site.items)
    items.each do |item|

      ind=ind+1
      break if ind>count && count>0
      next if !site.disabled.nil? && !site.disabled.empty? && !item.css(site.disabled).empty?
      
      title = item.css(site.title)
      #p "title", title
      title = item.css(site.href) if title.empty?
      next if title.empty?


      
      link_pref = site.link_pref
      link_pref.chomp('/')
      link_pref = 'http://'+url.split('//')[1].split('/')[0] if link_pref.nil?

      link = title.attr('href')
      link = item.css(site.href).attr('href') if link.nil?
      link = item.css(site.href).attr('title') if link.nil?
      link = site.link_pref.empty? ? link.text : link_pref + link
      
      price = item.css(site.price)
      price = price[0] if price.count>1
      price = price.text.gsub(/([  ])/, '').sub(/ /,'').to_i


      detail = item.css(site.detail).text if !site.detail.nil? && !site.detail.empty?
      
      case site.id_method
      when 'title' 
        id = title.attr(site.id_field).text.to_i
      when 'link'  
        id = link.split('/').last.to_i
      when 'field'
        id = item.attr(site.id_field).split(site.id_split).last.to_i
      when 'css'
        id = item.css(site.id_field).text.split(site.id_split).last.to_i
      end

      link = link.text if link.class==Nokogiri::XML::Attr
      hash_params = { link: link.gsub('//','/').gsub(':/','://'), title: title, price: price, detail: detail, warranty: '', site: site.name}
      if site.title.class.to_s == 'String'
        hash_params[:title] = title.text    
      elsif !site.title_field.empty? && (site.title_field.include? '+')
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

      

      if !site.warranty_css.empty?
        case site.warranty_method
        when 'page' # гарантия видна только на странице товара
          warranty = detail_from_link(link,site.warranty_css,'.prop :contains("аранти")',site.cookie)
          warranty = warranty.split(site.warranty_split).last if !site.warranty_split.empty?
        when 'last' # последнее совпадение
          warranty = item.css(site.warranty_css)
          warranty = warranty.last.next_sibling.text
        when 'split'
          warranty = item.css(site.warranty_css).text
          warranty = warranty.split(site.warranty_split).last
        #when 'sub' # как подстрока 
        #  warranty = item.css(site.warranty_css).text
        #  warranty = warranty.sub(param_hash[:warranty][:sub],'').strip
        end
        hash_params[:warranty] = warranty
      end

      showings.store( price*10000000 + id, hash_params)
      end
    #end
    p 'showings.count:'+showings.count.to_s
    showings
  end 

  def get_prices(name, test = false)

    showings ={}
    if params[:search_category] && params[:search_category]!='0'
      cat = SearchCategory.find(params[:search_category])
#      p "cat.urls.count:" + cat.urls.count.to_s
      current_user.update_attributes(:progress => 'start')
        i =0 
        cat.urls.where(disabled: false).each do |url| 
          sh = parse_all(url.url,url.site,name)
          showings = showings.merge(sh) if !sh.nil?
          i=i+1
      end
    end
    showings = showings.sort
  
  end

end