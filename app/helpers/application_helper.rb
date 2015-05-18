module ApplicationHelper

  def edit_delete(element,subcount = nil)
    content_tag :td,{:class=>"edit_delete"} do
     #ed = link_to "", edit_polymorphic_path(element), :class=>"icon icon_edit"
     ed = link_to "", polymorphic_path(element), :class=>"icon icon_edit", data: { modal: true }
     subcount ||= 0
     if subcount>0 
      de = content_tag("span","",{:class=>'icon icon_remove disabled'})
     else
      de = link_to "", element, method: :delete, data: { confirm: 'Действительно удалить?' }, :class=>"icon icon_remove" 
     end 
     ed + de
    end
  end


end
