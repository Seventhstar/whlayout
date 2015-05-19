# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_whouse_show = (wh_id)->
  $.get '/whouses/'+wh_id, "", null, "script"

$(document).ready ->
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