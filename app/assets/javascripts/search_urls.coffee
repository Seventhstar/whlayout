# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#search_url_search_category_id').chosen(width: '200px', disable_search: true)
	$('#search_url_search_site_id').chosen(width: '200px', disable_search: true)
	$('#edit_search_url_1').on 'click','.copy', ->
		alert(copyFromClipboard())
