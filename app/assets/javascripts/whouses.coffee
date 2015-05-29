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

timeoutId = undefined

$(document).ready ->

  $('#whouses_search select#whouse_id').chosen(width: '340px', disable_search: true).on 'change', ->
    if !$('#whouse_id').val() 
      $('#btn-add-el').hide();
    else
      $('#btn-add-el').show();
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

    