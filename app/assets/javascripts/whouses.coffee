# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_whouse_show = (wh_id)->
  $.get '/whouses/'+wh_id, "", null, "script"

@update_whel = ->
  #param = {'search': $('#search').val(), 'whouse_id': $('#whouses_search select#whouse').val()}
  param = $('form').serialize()

  $.get 'whouse_elements/', param, null, 'script'
  return

@upd_param = (param)->
  $.ajax
      url: '/ajax/upd_param'
      data: param
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
     return


@add_el_to_wh = (dt,func)->
  $.ajax
      url: '/ajax/add_wh_el'
      data: dt
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        $('#search').val ''
        setTimeout(func,1)
        return
     return

@del_el_from_wh = (el_id,func)->
   del = confirm('Действительно удалить элемент из склада?')
   if !del
      return
   $.ajax
      url: '/ajax/del_wh_el'
      data: 'el_id': el_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        setTimeout(func,1)
        return
    return     

@disable_input = (cancel=true) -> 
 item_id = $('.icon_apply').attr('item_id')
 $cells = $('.editable')
 $cells.each ->
  _cell = $(this)
  _cell.removeClass('editable')
  if cancel
    _cell.html _cell.attr('last_val')
  else
    _cell.html _cell.find('input').val()    
  return
 
 $cell = $('td.app_cancel')  
 $cell.removeClass('app_cancel')
 $cell.html '<span class="icon edit" item_id="'+item_id+'"></span><span class="icon delete" item_id="'+item_id+'"></span>' 


timeoutId = undefined

$(document).ready ->

  $('#whouses_search select#whouse_id').chosen(width: '340px', disable_search: true).on 'change', ->
    if !$('#whouse_id').val() 
      $('#btn-add-el').hide();
      $('#wh_el_count').hide();
    else
      $('#btn-add-el').show();
      $('#wh_el_count').show();
    update_whel()

  $('#whouses_search input').keyup ->
    c = String.fromCharCode(event.keyCode)
    isWordcharacter = c.match(/\w/)
    if isWordcharacter or event.keyCode == 8
      s = 1
      clearTimeout timeoutId
      timeoutId = setTimeout('update_whel()', 800)
    false

  
  $('.container').on 'click', '#whouses_search span#btn-add-el', ->
    wh_id = $('#whouse_id').val()
    #alert($('form').serialize())
    add_el_to_wh($('form').serialize(),'update_whel()')

  $('.container').on 'click', '.whouse_elements span.btn-sm', ->
    param = $('[name^=wh_el]')
    wh_id = $('#wh_el_whouse_id').val()
    add_el_to_wh(param.serialize(),'update_whouse_show('+wh_id+')')

  $('.container').on 'click', '.whouse_elements span.delete', ->
    wh_id = $('#wh_el_whouse_id').val()
    el_id = $(this).attr('el_id')
    del_el_from_wh(el_id,'update_whouse_show('+wh_id+')')

  $('.container').on 'click', '.whouses_index span.delete', ->
    wh_id = $('#whouse_id').val()
    el_id = $(this).attr('item_id')
    del_el_from_wh(el_id,'update_whel()')
  

 # редактирование данных в таблица

  $('.container').on 'click', 'span.edit', ->
    item_id = $(this).attr('item_id')
    $row = $(this).parents('')
    disable_input()
    $cells = $row.children('td').not('.edit_delete')
    table = $(this).closest('table')
    $cells.each ->
      _cell = $(this)
      _cell.addClass('editable')
      val = _cell.html()      
      _cell.data('text', val).html ''
      _cell.attr('last_val',val)
      #_cell.attr('ind', table.children('th').nth-child(_cell.index()+1))
      #alert(table.find('th:eq('+(_cell.index()+1)+')').attr('fld'))
      _cell.attr('ind', table.find('th:eq('+_cell.index()+')').attr('fld'))
      type = _cell.attr('type')
      #alert(type==undefined)
      type = if type == undefined then 'text' else type      
      $input = $('<input type="'+type+'" name=upd['+table.find('th:eq('+_cell.index()+')').attr('fld')+'] />').val(_cell.data('text')).width(_cell.width() - 16)
      _cell.append $input
      return

    $cell = $row.children('td.edit_delete')  
    $cell.addClass('app_cancel')
    $cell.html '<span class="icon icon_apply" item_id="'+item_id+'"></span><span class="icon icon_cancel" item_id="'+item_id+'"></span>'
    
   # отмена редактирования
   $('.container').on 'click', 'span.icon_cancel', ->   
     disable_input()

   # отправка новых данных
   $('.container').on 'click', 'span.icon_apply', ->  
     model = $(this).closest('table').attr('model')
     inputs = $('input[name^=upd]')
     #alert(inputs.serialize())
     upd_param(inputs)
     disable_input(false)