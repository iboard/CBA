hide_links = ->
  $(".comment-links").hide()
  
this.showSideTab = (what) ->  
  $(".comment-links").hide()
  what.show('slide', {direction: 'right', class: 'comment-links'},250)

this.hideWithDelay = (what) ->
  if what
    setTimeout("hideSideTab($(\"#"+what+"\"))", 5000)

this.hideSideTab = (what) ->  
  style = what.attr('style')
  if style && style.match /display: block/
    what.hide('slide',{direction: 'right',class: 'side-tab'}, 250)

$(document).ready ->
  $(".comment-links").hide()
  
  

