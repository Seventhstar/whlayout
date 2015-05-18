module ApplicationHelper

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


end
