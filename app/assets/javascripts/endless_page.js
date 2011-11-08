var currentPage = 1;
var state_scroll_to_top_link = 0;
var bottom_announced = 0;

function checkScroll() {
  if (nearBottomOfPage()) {
    currentPage++;
    $('#load_more_link').click();
  } else {
    setTimeout("checkScroll()", 500);
  }  
}

function controllToTopLink() {
  if ( $('#scroll-to-top')) {
    if( onTop() ) {
      if( state_scroll_to_top_link == 1 ) {
        $('#scroll-to-top').effect('puff',{},500);
        state_scroll_to_top_link = 0;
      }
    } else {
      if( state_scroll_to_top_link == 0 ) {
        $('#scroll-to-top').fadeTo(250,0.75);
        state_scroll_to_top_link = 1;
      }
      
      if(scrolledPercentage() >= 99) { 
        if( bottom_announced == 0){
          $('#scroll-to-top').effect('pulsate',{times: 2},250);
          bottom_announced = 1;
        }
      } else {
        bottom_announced = 0;
      }
      
    }
    setTimeout("controllToTopLink()", 500);
  }
}

function nearBottomOfPage() {
  return scrollDistanceFromBottom() < 250;
}

function scrollDistanceFromBottom(argument) {
  return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

function scrolledPercentage() {
  return ((document.body.scrollHeight)-scrollDistanceFromBottom())/document.body.scrollHeight*100;
}

function onTop() {
  var visible=0;
  var f = scrolledPercentage()-visible;
  $("#scroll-position").html(sprintf("%d%",f));
  return(window.pageYOffset <= 0);
}

$(document).ready( function() {
  $(".pagination_box:first").hide();
  $('#scroll-to-top').hide();
  controllToTopLink();
  checkScroll();
});
