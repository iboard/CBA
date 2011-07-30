var currentPage = 1;
var state_scroll_to_top_link = 0;

function checkScroll() {  
  if (nearBottomOfPage()) {
    currentPage++;
    $('#load_more_link').click();
  } else {
    setTimeout("checkScroll()", 500);
  }  
}

function controllToTopLink() {
  if( onTop() ) {
    if( state_scroll_to_top_link == 1 ) {
      $('#scroll-to-top').fadeTo(250,0.0);
      state_scroll_to_top_link = 0;
    }
  } else {
    if( state_scroll_to_top_link == 0 ) {
      $('#scroll-to-top').fadeTo(250,0.75);
      state_scroll_to_top_link = 1;
    }
  }
  setTimeout("controllToTopLink()", 500);
}

function nearBottomOfPage() {
  return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
  return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

function onTop() {
  var where = ((document.body.scrollHeight)-scrollDistanceFromBottom())/document.body.scrollHeight*100;
  var visible=0;
  var f = where-visible;
  $("#scroll-position").html(sprintf("%d%",f));
  return(window.pageYOffset <= 0);
}

$(document).ready( function() {
  $('#scroll-to-top').hide();
  controllToTopLink();
  checkScroll();
});
