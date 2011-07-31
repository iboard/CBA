function showSideTab(what){  
  $(".comment_links").hide();
  what.show();
}

function hideWithDelay(what) {
  var style = $("#"+what).attr('style');
  setTimeout("hideSideTab($(\"#"+what+"\"))", 4000);
}

function hideSideTab(what){  
  what.hide();
}


$(document).ready(function(){
  $(".comment_links").hide();
});

