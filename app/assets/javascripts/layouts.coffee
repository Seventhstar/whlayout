# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@update_layout_show = (lay_id)->
  $.get '/layouts/'+lay_id, "", null, "script"

$(document).ready ->
  $('.container').on 'click', 'span.btn-sm', ->
    param = $('[name^=lay_el]')
    lay_id = $('#lay_el_layout_id').val()
    $.ajax
      url: '/ajax/add_lay_el'
      data: param.serialize()
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        update_layout_show(lay_id)
        return
     return

  $('.container').on 'click', '#layout_elements span.delete', ->
    lay_id = $('#lay_el_layout_id').val()
    el_id = $(this).attr('el_id')
    del = confirm('Действительно удалить?')
    if !del
      return
    $.ajax
      url: '/ajax/del_lay_el'
      data: 'el_id': el_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        update_layout_show(lay_id)
        return
    return

    