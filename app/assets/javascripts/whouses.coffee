# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_whouse_show = (wh_id)->
  $.get '/whouses/'+wh_id, "", null, "script"

@update_whel = ->
  param = {'search': $('#search').val()}
  $.get 'whouse_elements/', param, null, 'script'
  return

$(document).ready ->

  $('#whouses_search input').keyup ->
    c = String.fromCharCode(event.keyCode)
    isWordcharacter = c.match(/\w/)
    if isWordcharacter or event.keyCode == 8
      s = 1
      setTimeout 'update_whel()', 400
    false

  $('.container').on 'click', 'span.btn-sm', ->
    param = $('[name^=wh_el]')
    wh_id = $('#wh_el_whouse_id').val()
    $.ajax
      url: '/ajax/add_wh_el'
      data: param.serialize()
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        update_whouse_show(wh_id)
        return
     return

  $('.container').on 'click', '#whouse_elements span.delete', ->
    wh_id = $('#wh_el_whouse_id').val()
    el_id = $(this).attr('el_id')
    del = confirm('Действительно удалить?')
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
        update_whouse_show(wh_id)
        return
    return