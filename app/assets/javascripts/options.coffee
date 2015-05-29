# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
# удаляем элемент справочника
  $(document).on 'click', '.option_content span.delete', ->
    url = $('form').attr('action')
    item_id = $(this).attr('item_id')
    del_url = url + '/' + item_id
    del = confirm('Действительно удалить?')
    if !del
      return
    $.ajax
      url: del_url
      data: '_method': 'delete'
      dataType: 'json'
      type: 'POST'
      complete: ->
        $.get url, null, null, 'script'
        return
    return

