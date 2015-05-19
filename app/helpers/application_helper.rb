module ApplicationHelper

  def is_admin?
    current_user.admin? 
  end


  def edit_delete(element,subcount = nil)
    content_tag :td,{:class=>"edit_delete"} do
     #ed = link_to "", edit_polymorphic_path(element), :class=>"icon icon_edit"
     ed = link_to image_tag('edit.png'), edit_polymorphic_path(element) 
     subcount ||= 0
     if subcount>0 
      de = image_tag('delete-disabled.png')
     else
      de = link_to image_tag('delete.png'), element, method: :delete, data: { confirm: 'Действительно удалить?' }
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


end
