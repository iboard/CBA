var currentPage = 1;

function checkScroll() {
  if (nearBottomOfPage()) {
    currentPage++;
    $('#load_more_link').click();
  } else {
    setTimeout("checkScroll()", 500);
  }
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

$(document).ready( function() {
  checkScroll();
});