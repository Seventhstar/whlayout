// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require spin
//= require jquery.spin
//= require twitter/bootstrap
//= require chosen.jquery
//= require_tree .



var showNotifications = function(){ 
  $nt = $(".alert"); 
  
  setTimeout(function() {$nt.removeClass("in").addClass('out');}, 3000);
}

$( document ).ready(function() {
    showNotifications();
});

$(function() {

  $( document ).ajaxStop(function() {
    $('table.tableSorter').tableSort();

  });
  $('table.tableSorter').tableSort();


  //var table = document.getElementById('edit');
  //var table = $('.table').click();
  /*$('td').click(function()    {
        var td_val = $(this).html();
        var input_field = $('<input type="text" id="edit" value="' + td_val + '" />');
        $(this).html(input_field);
        $(input).focus();
    });*/



  $('#lay_el_element_id').chosen();
  $('#wh_el_element_id').chosen();


  $('.options-menu a').click(function(){ 
      $('.options-menu a.active').removeClass("active", 550, "easeInQuint");
      $(this).addClass("active");
      var url = "/" + $(this).attr("controller");
      $.get(url, null, null, "script");
      if (url!="/undefined") setLoc("options"+url);
  });


  $(document).on('click','#btn-send',function(e) {  
    
    var valuesToSubmit = $('form').serialize();
    var values = $('form').serialize();
    var url = $('form').attr('action');
    var empty_name = false;
    //alert(values);
    each(q2ajx(values), function(i, a) {
      if (i.indexOf("[name]") >0  && a=="" ) { empty_name = true; return false; }
    });

    if (!empty_name){
      $.ajax({
          type: "POST",
          url: url, //sumbits it to the given url of the form
          data: valuesToSubmit,
          dataType: 'JSON',  
          beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},         
          success: function(){$.get(url, null, null, "script");}
      });
    }
  });


});

    
