sidetab_timeouts = []

this.cancelSideTabTimeouts = ->
  for t in sidetab_timeouts
    clearTimeout(t)
  sidetab_timeouts = []

  
hide_links = ->
  $(".comment-links").hide()
  cancelSideTabTimeouts()
  
this.showSideTab = (what) ->  
  cancelSideTabTimeouts()
  $(".comment-links").hide()
  what.show('slide', {direction: 'right', class: 'comment-links'},250)
  
this.hideWithDelay = (what,time) ->
  sidetab_timeouts.push setTimeout("hideSideTab($(\"#"+what+"\"))", time)

this.hideSideTab = (what) ->
  try
    style = what.attr('style')
    if style.match /display: block/
      this.cancelSideTabTimeouts()
      what.hide('slide',{direction: 'right',class: 'side-tab'}, 250)
  catch e
    # nothing
        
$(document).ready ->
  $(".comment-links").hide()
  
  

