// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  $("#searchfield").keyup(function(event){
    if( this.value.length > 2) {
      $.post($("#searchfield").parent().attr('action'), $(this).serialize(), null, "script");  
      return false;
    }
  });
});

