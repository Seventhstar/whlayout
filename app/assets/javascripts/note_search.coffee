# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

timeoutId = undefined

@update_notesearch = ->
  param = $('form').serialize()
  url = 'note_search?'+param
  $.get url, "", null, "script"
  setLoc(url);

@update_progress = ->
  #alert(1)
  $.get '/ajax/check_status', (data) ->
    #alert 'Data Loaded: ' + data
  #setTimeout('update_progress()', 1500)

$(document).ready ->

  if $('#progress').length > 0
     setTimeout('update_progress()', 500);
  
  $('#note_search input').keyup ->
    c = String.fromCharCode(event.keyCode)
    isWordcharacter = c.match(/\w/)
    if isWordcharacter or event.keyCode == 8
      $(".goods_prices").spin()
      clearTimeout timeoutId
      timeoutId = setTimeout('update_notesearch()', 800)
    false

  $('#search_category').chosen(width: '200px', disable_search: true).on 'change', ->
    $(".goods_prices").spin()
    kw_id = $('#search_category').val()
    $('#search').val($('#kw_'+kw_id).val())
    timeoutId = setTimeout('update_notesearch()', 800)

