# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

timeoutId = undefined

@update_notesearch = ->
  param = $('form').serialize()
  $.get '/note_search?'+param, "", null, "script"


$(document).ready ->
  $('#note_search input').keyup ->
    c = String.fromCharCode(event.keyCode)
    isWordcharacter = c.match(/\w/)
    if isWordcharacter or event.keyCode == 8
      $(".goods_prices").spin()
      clearTimeout timeoutId
      timeoutId = setTimeout('update_notesearch()', 800)
    false
