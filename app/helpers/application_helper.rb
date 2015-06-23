module ApplicationHelper

  def is_admin?
    current_user.admin? 
  end


  def td_delete(element,subcount = nil)
    content_tag :td,{:class=>"edit_delete"} do
      de = link_to image_tag('delete.png'), element, method: :delete, data: { confirm: 'Действительно удалить?' }
    end
  end

  def td_span_delete(element,subcount = nil)
    content_tag :td,{:class=>"edit_delete"} do
      de = content_tag :span, "",{class: 'delete', el_id: element.id}
    end
  end

  def td_edit_delete(element,subcount = nil)
    content_tag :td,{:class=>"edit_delete"} do
     #ed = link_to "", edit_polymorphic_path(element), :class=>"icon icon_edit"
     ed = link_to image_tag('edit.png'), edit_polymorphic_path(element) 
     subcount ||= 0
     if subcount>0 
      de = image_tag('delete-disabled.png')
     else
      de = link_to image_tag('delete.png'), element, method: :delete, data: { confirm: 'Действительно удалить -?' }
     end 
     ed + de
    end
  end

  def sp_edit_delete(element,subcount = nil)
    content_tag :td,{:class=>"edit_delete"} do
     #ed = link_to "", edit_polymorphic_path(element), :class=>"icon icon_edit"
     #ed = link_to image_tag('edit.png'), polymorphic_path(element), :class=>"icon icon_edit", data: { modal: true }
      ed = content_tag :span, "",{class: 'icon edit', item_id: element.id}
     subcount ||= 0
     if subcount>0 
      de = content_tag("span","",{:class=>'icon delete disabled'})
     else
      de = content_tag("span","",{:class=>'icon delete', item_id: element.id})
     end 
     ed + de
    end
  end


  def option_link( page,title )
    css_class = @page_data == page ? "active" : nil
    link_to title, '#',{:class =>"list-group-item #{css_class}", :controller => page}
  end


  def option_li( page,title )
    css_class = @page_data == page ? "active" : nil
    content_tag :li, {:class =>css_class } do
      link_to title, '#',{:class =>"list-group-item #{css_class}", :controller => page}
    end
  end

  def new_item_header( cls )
  case cls
    when "Element"
      "Новый элемент"
    when "Whouse"
      "Новый склад"
    else
      cls
    end
  end

  def list_header( cls )
  case cls
    when "Element"
      "Список элементов"
    when "Whouse"
      "Список складов"
    else
      cls
    end
  end

  def short_name(txt)
  	if txt.length >130
  		txt[0..130]+' ...'
  	else
  		txt
  	end
  	
  end


end
