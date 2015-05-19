# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@update_layout_show = (lay_id)->
  $.get '/layouts/'+lay_id, "", null, "script"

$(document).ready ->
  $('.new_layout_element').on 'click', 'span.btn-sm', ->
    #alert(1)
    param = $('form').serialize()
    lay_id = $('#layout_element_layout_id').val
    $.ajax
      url: '/ajax/add_lay_el'
      data: param
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        update_layout_show(lay_id)
        return
     return
